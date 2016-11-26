package Control::Plugin::DB;
use Mojo::Base 'Mojolicious::Plugin';
use FindBin qw($Bin);
use lib "Bin/../../lib";
use Schema;

sub register {
	my ($self, $app) = @_;
	
	$app->helper( db => sub {		
		my $c = shift;
		$c->app->schema;
	});
	
	$app->helper( schema => sub {
		my $c = shift;
		return Schema->connect(
			$c->app->config->{'db'}->{'dbi'},
			$c->app->config->{'db'}->{'user'},
			$c->app->config->{'db'}->{'passwd'},
			{
				quote_names => 1,
				mysql_enable_utf8 => 1,
			}
		);
	});
	1;
}

1;