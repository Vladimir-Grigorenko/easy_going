package Control::Plugin::Session;
use List::Util qw(shuffle);
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self,$app) = @_;

    $app->routes->add_condition( session => sub {
        my ($r, $c, $captures, $pattern ) = @_;		
        $c->check_session() ? 1 : 0;
    });
	
	$app->helper( check_session => sub {
		my ($c) = @_;		

		my $check = $c->session( $app->config->{'session'}->{'cookie_name'} )
			? 1 : $c->set_session();
			
		my $session = $c->session( $app->config->{'session'}->{'cookie_name'} );
		$c->stash({ session => $session });
		
		# Данные пользователя
		if( $session->{'user_id'} ){
			my $m = $c->model('User');
			my $info = $m->get( $session->{'user_id'} );
			$c->stash( 'user', $info );
		}

		# Корзина
		$c->cart_list();
		
		$c->res->headers->header( 'Server' => 'Shtogarenko.pp.ua' );

		$check;
	});

	$app->helper( set_session => sub {
		my ($c) = @_;
		my $rnd = time . join( '', shuffle ('A'..'Z', 0..9, 'a'..'z','!','-') );		
		my $sid = md5_hex( $rnd );

		$c->session( { $app->config->{'session'}->{'cookie_name'} => {
			sid => $sid
		} } );
		$c->csrf();
		return 1;
	});
	
	$app->helper( csrf => sub {
		my ($c) = @_;
		my $rnd = time . join( '', shuffle ('A'..'Z', 0..9, 'a'..'z','!','-') );
		my $h = $c->session(  $app->config->{'session'}->{'cookie_name'}  );
		$h->{'csrf'} = md5_hex( $rnd );		
		$c->session( { $app->config->{'session'}->{'cookie_name'} => $h } );
		1;
	});
	
	$app->helper( add2session => sub {
		my ( $c, $key, $value ) = @_;
		my $h = $c->session(  $app->config->{'session'}->{'cookie_name'}  );
		$h->{$key} = $value;
		$c->session( { $app->config->{'session'}->{'cookie_name'} => $h } );
		1;
	});	
	
	return 1;
}

1;