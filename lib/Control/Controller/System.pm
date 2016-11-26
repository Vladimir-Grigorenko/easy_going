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

sub service_out {
	my $c = shift;

  #say $c->req->url->to_abs;
  #say $c->req->url->to_abs->userinfo;
  #say $c->req->url->to_abs->host;
  #say $c->req->headers->user_agent;
  #say $c->req->body;
  #say $c->req->text;
  #say $c->req->params->to_hash;
  #say $c->req->json;

	$c->render( text => 'Service dont work!!!' );
}

sub login {
	my $c = shift;  
}

sub login_confirm {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->reply->not_found unless $data->{'code'};
	
	my $res = $c->app->ua->post('/api/user/login/confirm.json' => form => { code => $data->{'code'} } );
	my $json = $res ? $res->res->json : undef;
		
	if( $res->res->code == 200 && $json ){
		if( $json->{'success'} ) {
			$c->session( { $c->app->config->{'session'}->{'cookie_name'} => $json->{'message'} } );
			return $c->redirect_to('profile');
		}
		else{
			$c->flash({ error => $json->{'message'} });
			return $c->redirect_to('login-confirm-error');
		}
	}
	else{    
		return $c->redirect_to('login-confirm-error');
	}
}

sub access {
	my $c = shift;
	$c->redirect_to('profile');
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
