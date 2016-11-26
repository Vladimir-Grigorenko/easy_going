package Control::Controller::Catalog;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ( $init, $m, %ids ) = ( '', '', () );

sub _init {
	my $c = shift;
	$m = $c->model('default');
	$m->get_default_data( $c );
	$init = $c->c_init();
	$c->_category();
	1;
}

sub default {
	my $c = shift;
	$c->portal;
}

sub item {
	my $c = shift;  
	return $c->reply->not_found unless $c->_init();
  
	my ( $m ) = ('');
	$m = $c->model('Product');
	(my $url = $c->stash('item'))=~s/(\.html|\.htm)//i;
	
	# Данные по продукту
	my $res = $m->get_v_product_info({
		category_id => $c->stash->{ $c->config->{'project_name'} }->{'category'}->{'category_id'},
		product_id => $c->stash->{ $c->config->{'project_name'} }->{'product_id'}
	});
	
	# SEO
	my $site = $c->stash('site') || {};
	$site->{'title'} = $res->{'title'} . " купить с доставкой по Украине | hilt.com.ua ";
			
	# Картинки
	$m = $c->model('Image');
	my $img = $m->get_product_image( {
		product_id => $res->{'product_id'}
	} );
	$res->{'images'} = $img;
	
	# Характреристики
	$m = $c->model('Feature');
	my $feature = $m->get_v_product2feature( $res->{'product_id'} );
	$res->{'feature'} = $feature;
	
	# Акции
	$m = $c->model('Event');
	my $sale = $m->product_is_sale( $res->{'product_id'} );
	if( $sale ){
		$res->{'sale'} = $sale;
		my $price = $m->get_product_price( $sale->{'sale_id'}, $res->{'product_id'} );
		if( $price ){
			$res->{'price'}->{'prev'} = $res->{'price'}->{'current'};
			$res->{'price'}->{'current'} = $price->{'price'};
			$res->{'price'}->{'percent'} = 100 - int( $res->{'price'}->{'current'} * 100 / $res->{'price'}->{'prev'});
		}
	}
		
	$c->stash->{ $c->config->{'project_name'} }->{'product_item'} =	$res;
	$c->render(template => 'pages/catalog/item');
}

sub portal {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->reply->not_found unless $c->stash->{ $c->config->{'project_name'} }->{'category_all'};
	
	my @cat = @{ $c->stash->{ $c->config->{'project_name'} }->{'category_all'} };

	# SEO
	my $cat = $c->stash->{ $c->config->{'project_name'} }->{'category'};
	my $site = $c->stash('site') || {};
	$site->{'title'} = $cat->{'title'} . " купить в интернет-магазине | hilt.com.ua";
		
	# Товары
	my $m = $c->model('Product');
	my $res  = $m->get_product2category(
		{
			'category_id' => { IN => \@cat }
		},
		$init
	);
	
	# Картинки
	$m = $c->model('Image');	
	for my $item ( @{$res->{'data'}} ){		
		my $img = $m->get_product_image( {product_id => $item->{'product_id'} } );
		$item->{'images'} = $img;
	}	
	
	# Характеристики
	$m = $c->model('Feature');	
	for my $item ( @{$res->{'data'}} ){		
		my $feature = $m->get_v_product2feature( $item->{'product_id'} );
		$item->{'feature'} = $feature;
	}	

	# Акции
	$m = $c->model('Event');
	for my $item ( @{$res->{'data'}} ){
		my $sale = $m->product_is_sale( $item->{'product_id'} );
		if( $sale ){
			$item->{'sale'} = $sale;
			my $price = $m->get_product_price( $sale->{'sale_id'}, $item->{'product_id'} );
			if( $price ){
				$item->{'data'}->{'price'}->{'prev'} = $item->{'data'}->{'price'}->{'current'};
				$item->{'data'}->{'price'}->{'current'} = $price->{'price'};
				$item->{'data'}->{'price'}->{'percent'} = 100 - int( $item->{'data'}->{'price'}->{'current'} * 100 / $item->{'data'}->{'price'}->{'prev'});
			}
		}
	}
	
	$c->stash->{ $c->config->{'project_name'} }->{'products'} = $res;
	
	$c->stash->{ $c->config->{'project_name'} }->{'products_pagination'} = $c->pagination(
		$init->{'page'} || 1,
		$c->count_pages( $res->{'count'} ),
		{ round => 0 }
	);
	
	# 
	#
	$m = $c->model('Filter');
	my $filter = $m->get_filter2catalog( {
		product => $res->{'all_product_id'}
	} );
		
	$c->stash->{ $c->config->{'project_name'} }->{'filter'} = $filter;

	$c->stash->{ $c->config->{'project_name'} }->{'price'} = {
		min => $res->{'filter'}->{'price'}->{'min'},
		max => $res->{'filter'}->{'price'}->{'max'},
	};
		
	$c->render(template => 'pages/catalog');
}


sub _category {
	my $c = shift;
	return $c->reply->not_found unless $c->stash('path') || $c->stash('item');
	my $arr = [{ url => '/', title => 'На главную' }];
	my $m = $c->model('Category');
	
	if( $c->stash('path') ) {
		my $path = "/".$c->stash('path');
	
		my ( $res, $error ) = $m->find({ url2site => $path });	
	
		unless( @{ $res } ){
			return $c->reply->not_found;
		}
		
		my ( $res2, $error2 ) = $m->find({
			instr => {
				RLIKE => '[[:<:]]'.$res->[0]->{'category_id'}.'[[:>:]]'
			}
		});
	
		for my $item ( @{$res2} ) {
			push @{ $arr }, {
				title => $item->{'title'},
				url => $item->{'url2site'},
				category_id => $item->{'category_id'},
				instr => $item->{'instr'},
			};		
		}
		$c->stash->{ $c->config->{'project_name'} }->{'category'} = $arr->[-1];
		$c->stash->{ $c->config->{'project_name'} }->{'category_all'} = $arr->[-1]->{'instr'} ? [ $arr->[-1]->{'instr'}=~/\d+/g ] : [];
		

	}
	elsif ( $c->stash('item') ){
		my $item = $c->stash('item');
		$item =~ /^p(\d+)/;
		if( $1 ){
			$m = $c->model('Product');
			my $res = $m->get_v_product_info( { product_id => $1 } );
			$c->stash->{ $c->config->{'project_name'} }->{'product_id'} = $1;
			
			if( $res && %{ $res } ){
				
				$m = $c->model('Category');
				my ( $res2, $error2 ) = $m->find({
					instr => {
						RLIKE => '[[:<:]]'.$res->{'category_id'}.'[[:>:]]'
					}
				});

				for my $item ( @{$res2} ) {
					push @{ $arr }, {
						title => $item->{'title'},
						url => $item->{'url2site'},
						category_id => $item->{'category_id'},
						instr => $item->{'instr'},
					};
				}				

				push @{ $arr }, {
					title => $res->{'title'}
				};
				$c->stash->{ $c->config->{'project_name'} }->{'category'} = $arr->[-2];
				$c->stash->{ $c->config->{'project_name'} }->{'category_all'} = $arr->[-2]->{'instr'} ? [ $arr->[-2]->{'instr'}=~/\d+/g ] : [];
				
			}
			else{
				return $c->reply->not_found;
			}
		}
		else{
			return $c->reply->not_found;
		}
	}

	$c->stash->{ $c->config->{'project_name'} }->{'breadcrumbs'} = $arr;
	$arr;
}

1;