package Control::Controller::Api::Content::Page;
use Mojo::Base 'Mojolicious::Controller';

my ($m,$db,$page,$rows,$id) = ('','', 1, 20, 0);

sub _init {
  my $c = shift;
  $m = $c->model('user');
  $db = $c->db;
  $page = $c->param('page') ? $c->param('page') : $page;
  $rows = $c->param('rows') ? $c->param('rows') : $rows;
  $id = defined $c->param('id') ? $c->param('id') : 0;
  1;
}

sub get {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();  
  return $c->reply->not_found unless $id;
  
  my $h = $m->get( $db, $id );
  
  $c->render( json => $h );
}

sub update {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();
  
  my $data = $c->req->json;

  unless ( $data  ) {
	return $c->render( json => { failue => \1, message => 'Нет данных' } );
  }
  
  if ( $data && ref $data ne 'ARRAY' ) {
	return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
  }
  	  
  my ( $h, $error ) = $m->update( $db, $data );  
  $c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
}

sub set {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();
  
  my $data = $c->req->json;

  unless ( $data  ) {
	return $c->render( json => { failue => \1, message => 'Нет данных' } );
  }
  
  if ( $data && ref $data ne 'ARRAY' ) {
	return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
  }
  
  my ( $h, $error ) = $m->set( $c, $db, $data );
  $c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );  
}

sub remove {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();
  
  my $data = $c->req->json;

  unless ( $data  ) {
	return $c->render( json => { failue => \1, message => 'Нет данных' } );
  }
  
  if ( $data && ref $data ne 'ARRAY' ) {
	return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
  }

  my ( $h, $error ) = $m->remove( $db, $data );
  $c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
  
}

sub list {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();
  
  $c->render( json => $m->list( $db, $page, $rows ) );  
}
1;