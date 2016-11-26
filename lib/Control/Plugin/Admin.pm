package Control::Plugin::Admin;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self,$app) = @_;
    
	$app->routes->add_condition( is_admin => sub {
        my ($r, $c, $captures, $pattern ) = @_;
		#$c->redirect_to('index');
		return 1;
    });
	
	return 1;
}

1;