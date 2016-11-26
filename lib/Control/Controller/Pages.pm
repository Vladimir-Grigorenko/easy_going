package Control::Controller::Pages;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub default {
  my $c = shift;
  #say $c->dumper( $c->req->url->to_abs );
  #say $c->req->url->to_abs->userinfo;
  #say $c->req->url->to_abs->host;
  #say $c->req->headers->user_agent;
  #say $c->req->body;
  #say $c->req->text;
  #say $c->req->params->to_hash;
  #say $c->req->json;
  #say $c->dumper( $c->req->url->query->to_hash );
  $c->render( content => $c->req->url );
}

sub p404 {
  my $c = shift;
  $c->render(template => 'pages/404', status => 404);
}

sub index {
  my $c = shift;
  $c->stash(site => { tmpl => { param => { breadcrumb => 1 } } });
  #say Dumper( $c->session( $c->app->config->{'session'}->{'cookie_name'} ) )  
}

sub static {
  my $c = shift;
  $c->render( template => 'pages/static');
}

1;