package Control::Controller::System;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ($data,$init) = ({},{});
sub _init {
	my $c = shift;
	$init = $c->c_init();
	$data = $init->{'data'};
	1;
}

sub logout {
	my $c = shift;
	$c->session(expires => 1);
	$c->redirect_to('index');
}

sub login_confirm_error {
	my $c = shift;
	$c->render( template => 'pages/login_confirm_error' );
}


1;
