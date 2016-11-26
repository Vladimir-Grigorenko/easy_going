package Control::Plugin::Pages;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self,$app) = @_;
	
	$app->helper( get_page => sub {
		my ($c) = @_;
		$c->parse_url();
	});

	$app->helper( parse_url => sub {
		my ($c) = @_;
	});
	
	return 1;
}

1;