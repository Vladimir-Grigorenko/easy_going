package Control::Plugin::Auth;
use Mojo::Base 'Mojolicious::Plugin';
use Data::Dumper;

sub register {
	my ($self,$app) = @_;
		
    $app->routes->add_condition( is_auth => sub {
        my ($r, $c, $captures, $pattern ) = @_;	
		my $user = $c->stash('user');
		
		$user && $user->{'user_id'} && $user->{'access'} ? 1 : 0;
	});
	
	return 1;
}

1;