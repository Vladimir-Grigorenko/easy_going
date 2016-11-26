package Control::Controller::Profile;
use Mojo::Base 'Mojolicious::Controller';

my ($init) = ( {} );
sub _init {
	my $c = shift;
	$init = $c->c_init();
	return 1;
}

sub default {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	$c->render( template => 'pages/profile');
}

1;