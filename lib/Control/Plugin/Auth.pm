package Control::Plugin::Auth;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self,$app) = @_;
	
	$app->helper( mailrfc => sub {
		my ($c, $mail) = @_;
		my $user = $c->session('sid');
		$user && $user->{'uid'} ? 1 : 0;
	});
	
	return 1;
}

1;