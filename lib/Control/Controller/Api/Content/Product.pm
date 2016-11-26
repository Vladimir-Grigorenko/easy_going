package Control::Controller::Api::Content::Product;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ($m,$db,$id,$data, $init) = ('','', 0, '','');

sub _init {
	my $c = shift;
	$m = $c->model('Product');
	$init = $c->c_init();
	$data = $init->{'data'};
	1;
}

sub get {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();  
	return $c->reply->not_found unless $init->{'id'};

	my $h = $m->get_v_product_info( { product_id => $init->{'id'} } );
	
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
	
	if ( ref $data ne 'HASH') {
		$c->app->log->error('not valid param');
		return $c->render( json => { failue => \1, message => 'not valid param' } );
	}
	
	my @mandatory = ();
	my @entry = qw(url title description barcode rating user_id depth width heigth weight tag_title tag_description tag_keywords quantity unit_id);
	my @keys_in = keys %{$data};
	my @all = ( @mandatory, @entry );
	my @error = ();
	my (%data) = ();
	
	for my $item ( @mandatory ){
		my $find = 0;
		for my $key ( @keys_in ){
			if( $item eq  $key ){
				$find = 1;
				last;
			}
		}
		unless( $find ){
			push @error, $item;
		}
	}
	
	if( @error ){
		$c->app->log->error('not all param: '. join( ",", @error ));
		return $c->render( json => {
			failue => \1,
			message => 'not all param: '. join( ",", @error )
		});
	}

	%data = map {
		if( $data->{$_} ){
			$_ => $data->{$_};
		}
		else{
			();
		}
	} @all;
	
	my ( $res, $errstr ) = ('','');
	
	#
	# Проверка на штрихкод или наименование
	#
	if( $data->{'barcode'} ){
		$res = $m->get_product( { barcode => $data->{'barcode'} } );
	}
	else{
		$res = $m->get_product( { url => $data{'url'}, title => $data{'title'} } );
	}

	if( $res && ref $res eq "HASH" && %{$res} ) {
		( $res, $errstr ) = $m->update_product( $res->{'product_id'}, $data );
	}
	else{
		( $res, $errstr ) = $m->set_product( \%data );
	}
	
	#
	# Категории
	#
	if( $res && $data->{'category_id'} && $res->{'product_id'} ){
		my @cats = ref $data->{'category_id'} eq "ARRAY" ?
			@{ $data->{'category_id'} } : $data->{'category_id'};
		
		my ( $res2,$err ) = $m->remove_product2category( $res->{'product_id'} );
		if( $res2 ){
			for my $category ( @cats ){
				$m->set_product2category( {
					product_id => $res->{'product_id'},
					category_id => $category
				} );
			}
		}
	}
	
	#
	# Стоимость товара
	#
	if( $res && $res->{'product_id'} && ( $data->{'price_current'} || $data->{'price_prev'} || $data->{'price_supplier'} ) ){
		#say Dumper( $res );
		my $h = {
			product_id => $res->{'product_id'}
		};
		
		for my $item ( qw/price_current price_prev price_supplier/ ) {
			if( $data->{ $item } ){
				$h->{ $item } = $data->{$item};
			}
		}
		my ($res, $err) = $m->set_product_price( $h );
	}

	$c->render( json => $res );
}

sub remove {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	my $data = $c->req->json;
	
	unless ( $data  ) {
		return $c->render( json => {
			failue => \1,
			message => 'Нет данных'
		} );
	}
	
	if ( $data && ref $data ne 'ARRAY' ) {
		return $c->render( json => {
			failue => \1,
			message => 'Неправильная структура json'
		} );
	}
	
	my ( $h, $error ) = $m->remove( $data );
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );

}

sub list {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	$c->render( json => $m->list( $init->{'page'}, $init->{'rows'} ) );  
}
1;