package Control::Model::Product;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Data::Dumper;

sub get_product2category {
	my $model = shift;
	my $data = shift;
	my $attr = shift;
	my $db = $model->app->db;
	
	my $r = $db->resultset('Product2category')->search( $data ,{
		rows => $attr->{'rows'},
		page => $attr->{'page'},
		columns => [ qw/product_id category_id/ ],
		distinct => 1
	});  

	$r->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $r->all();
  
	my $rs = $db->resultset('Product2category')->search(
		$data,
		{
			columns => [ qw/product_id category_id/ ],
			distinct => 1
		}
	);
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');
	  	
	#  Все product_id  из категории - для фиильтов
	my @all_product_id = ();
	for my $item ( $rs->all() ){
		my $data = $model->get_v_product_info({ category_id => $item->{'category_id'}, product_id => $item->{'product_id'} });
		push @all_product_id, $item->{'product_id'}
									if $data && ref $data eq "HASH";
	}
	
	# Продукты с page и rows
	my @products = ();
	for my $item ( @res ){
		my $data = $model->get_v_product_info({ category_id => $item->{'category_id'}, product_id => $item->{'product_id'} });
		$item->{'data'} = $data
					if $data && ref $data eq "HASH";
		
		push @products, $item->{'product_id'};
	}
	
	$rs = $db->resultset('ProductPrice')->search({
		'product_id' => { IN => \@all_product_id },
	},{
		columns => [
			{ 'min' => { min => 'me.current'} },
			{ 'max' => { max => 'me.current'} }
		]
	});
	
	$rs->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res2 = $rs->all();
	
	{
		success =>\1,
		count => scalar@all_product_id,
		page => $attr->{'page'},
		rows => $attr->{'rows'},
		data => \@res,
		all_product_id => \@all_product_id,
		filter => {
			price => {
				min => $res2[0]->{'min'} ? int($res2[0]->{'min'}/100) : 0,
				max => $res2[0]->{'max'} ? int($res2[0]->{'max'}/100) : 0
			}
		}
	};	
	
}

sub set_product2category {
	my $model = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	
	$db->storage->txn_begin();
	
	try {
		my $res = $db->resultset('Product2category')->create( $data );
		for my $key ( $res->columns ) {
			$h->{ $key } = $res->$key if defined $res->$key;
		}		
		$db->storage->txn_commit();
		return $h;
	}
	catch {
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	};	
}

sub remove_product2category{
	my $model = shift;
	my $product_id = shift;
	my $db = $model->app->db;
	
	$db->storage->txn_begin();
	
	try {
		$db->resultset('Product2category')->search({ product_id => $product_id })->delete();
		$db->storage->txn_commit();
		return 1;
	}
	catch {
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	};
	
}

sub get_product {
	my $model = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	my $res = $db->resultset('Product')->find( $data );
	
	if( $res ){
		for my $key ( $res->columns ) {
			$h->{ $key } = $res->$key if defined $res->$key;
		}
		return $h;
	}
	return undef;
}

sub get_v_product_info {
	my $model = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	my $res = $db->resultset('VProductInfo')->find( $data );	
	if( $res ){
		for my $key ( $res->columns ) {
			$h->{ $key } = $res->$key if defined $res->$key;
		}
		my $price = $model->get_product_price( { product_id => $h->{'product_id'} } );
		$h->{'price'} = $price;
		return $h;
	}	
	return undef;	
}

sub get_product_price {
	my $model = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	my $res = $db->resultset('ProductPrice')->find( $data );
	if( $res ){
		for my $key ( $res->columns ) {
			$h->{ $key } = $res->$key if defined $res->$key;
		}
		$h->{'current'} = int($h->{'current'}/100) if $h->{'current'};
		$h->{'prev'} = int($h->{'prev'}/100) if $h->{'prev'};
		return $h;
	}
	return undef;
}

sub set_product_price {
	my $model = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	my $res = $db->resultset('ProductPrice')->find( {
		product_id => $data->{'product_id'}
	} );
	my %cols = map{ $_ => 1 } $db->source('ProductPrice')->columns;
	
	$db->storage->txn_begin();
	try {
		if( $res ){
			$res->current( $data->{'price_current'} ) if $data->{'price_current'};
			$res->prev( $data->{'price_prev'} ) if $data->{'price_prev'};
			$res->supplier( $data->{'price_supplier'} ) if $data->{'price_supplier'};
			$res->date_update(\'NOW()');
			$res->update();
		}
		else{
			
			for my $item ( keys %{ $data } ){
				my $value = $data->{ $item };
				$item =~s /price_//ig;
				if( $cols{$item} ){
					$h->{ $item } = $value;
				}
			}
			
			$res = $db->resultset('ProductPrice')->create( $h );
		}
		$db->storage->txn_commit();
		return $data;
	}
	catch {
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	}; 	
}

#
#  in \%data
#
sub set_product {
	my $model = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	
	$db->storage->txn_begin();
	try {
		my $res = $db->resultset('Product')->create( $data );
		
		for my $key ( $res->columns ) {
			$h->{ $key } = $res->$key if defined $res->$key;
		}
		
		$db->storage->txn_commit();
		return $h;
	}
	catch {
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	};  
}

sub update_product {
	my $model = shift;
	my $product_id = shift;
	my $data = shift;
	my $db = $model->app->db;
	my $h = {};
	my $res = $db->resultset('Product')->find( { product_id => $product_id } );
	
	for my $item ( qw/product_id date_create date_update/ ){
		delete $data->{'product_id'};
	}
	
	if( $res ){
		for my $key ( $res->columns ) {
			$res->$key( $data->{$key} ) if $data->{$key};
		}
		$res->date_update(\'NOW()');
		$res->update();
		$data->{'product_id'} = $product_id;
		return $data;
	}
	
	return undef;	
}

sub remove {
	my $model = shift;
	return {};
}

1;