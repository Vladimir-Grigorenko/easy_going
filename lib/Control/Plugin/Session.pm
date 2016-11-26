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
		$c->res->headers->header( 'Server' => 'Shtogarenko.pp.ua' );

		my $check = $c->session( $app->config->{'session'}->{'cookie_name'} ) ? 1 : $c->set_session();
		my $user = $c->session( $app->config->{'session'}->{'cookie_name'} );
		$c->stash({ 'user' => $user });
		
		$check;
	});

	$app->helper( set_session => sub {
		my ($c) = @_;
		my $rnd = time . join( '', shuffle ('A'..'Z', 0..9, 'a'..'z','!','-') );		
		my $sid = md5_hex( $rnd );
		my $user = {
			sid => $sid
		};		
		$c->session( { $app->config->{'session'}->{'cookie_name'} => $user } );
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
	
	return 1;
}

1;