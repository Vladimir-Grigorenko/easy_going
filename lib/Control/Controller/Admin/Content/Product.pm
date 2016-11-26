package Control::Controller::Admin::Content::Product;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ($m, $init) = ('','');

sub _init {
	my $c = shift;
	$init = $c->c_init();
	$m = $c->model('Product');
	1;
}

sub list {
	my $c = shift;
	return return $c->reply->not_found unless $c->_init();  
	my $res = $m->get_product2category({});
	
	$m = $c->model('Image');
	
	for my $item ( @{$res->{'data'}} ){
		my $img = $m->product_list( {product_id => $item->{'product_id'} } );
		$item->{'images'} = $img->{'data'};
	}

	$c->stash->{ $c->app->config->{'project_name'} }->{'admin'}->{'products'} = $res;
	$c->stash->{ $c->config->{'project_name'} }->{'products_pagination'} =
		$c->pagination(
			$init->{'page'} || 1,
			$res->{'count'},
			{ round => 1 }
		);

	
	$c->render( template => 'admin/content/product/list' );
}

sub item {
	my $c = shift;
	return return $c->reply->not_found unless $c->_init();  

	my $res = $m->get_v_product_info({ product_id => $init->{'id'} });

	$m = $c->model('Image');
	
	my $img = $m->get_all_photo( {product_id => $init->{'id'} } );
	$res->{'images'} = $img;
	
	$c->stash->{ $c->app->config->{'project_name'} }->{'admin'}->{'product_item'} = $res;
	
	#say Dumper(  $res );
	
	$c->render( template => 'admin/content/product/item' );	
}

sub set {
	my $c = shift;
	return return $c->reply->not_found unless $c->_init();	
}
1;