package Control::Controller::Api::Content::Feature;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use Mojo::Util qw(trim);

my ($m,$id, $data,$init) = ('',0, undef,{});

sub _init {
	my $c = shift;
	$m = $c->model('Feature');
	$init = $c->c_init();
	$id = $init->{'id'};
	$data = $init->{'data'};	
	1;
}

sub get {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();  
	return $c->reply->not_found unless $id;
	
	my $h = $m->get( $id );
	
	$c->render( json => $h );
}

sub update {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	unless ( $data  ) {
		return $c->render( json => { failue => \1, message => 'Нет данных' } );
	}
	
	if ( $data && ref $data ne 'ARRAY' ) {
		return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
	}

	my ( $h, $error ) = $m->update( $data );  
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
}

sub set {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	unless ( $data  ) {
		return $c->render( json => { failue => \1, message => 'Нет данных' } );
	}
	
	if ( $data && ref $data ne 'ARRAY' ) {
		return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
	}
	
	my ( $h, $error ) = $m->set( $data );
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );  
}

sub remove {
  my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	unless ( $data  ) {
		return $c->render( json => { failue => \1, message => 'Нет данных' } );
	}
	
	if ( $data && ref $data ne 'ARRAY' ) {
		return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
	}
	
	my ( $h, $error ) = $m->remove( $data );
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
  
}

sub list {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	$c->render( json => $m->list( $init->{'page'}, $init->{'rows'} ) );  
}

sub set_feature2product {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
		
	my( $res,$err) = ( [],'' );
	my @ret = ();
	
	if( $id && $data && ref $data eq "HASH" ){
		my $feature = {};
		while ( my($key, $value) = each %{ $data} ){
			$feature->{ trim($key) } = $value;
		}
		( $res,$err ) = $m->set_feature2product( $id, $feature );
		push @ret, $err ? $err : $res;
	}
	else{
		$res = { failue => \1, massage => 'not all mandatory params' }; 
	}
	$c->render( json => $res );
}

1;