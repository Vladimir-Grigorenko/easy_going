package Control::Plugin::Category;
use Mojo::Base 'Mojolicious::Plugin';

my @cats = ();

sub register {
	my ($self,$app) = @_;
	
	$app->helper( get_categores => sub {
		my ($c) = @_;
		return \@cats;
	});

	$app->helper( get_category => sub {
		my ($c) = @_;
		my $rnd = int( rand(50_000) );
		return {
				cat_id => $rnd,
				name => 'title => '.$rnd,
				url => int( rand(5_000) ),
		};
	});
	
	return 1;
}

1;