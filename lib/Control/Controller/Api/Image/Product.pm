package Control::Controller::Api::Image::Product;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ( $files, $m, $ms, $id, $data, $init, $tmp_path_dir ) = ('', '', '', 0, [], {},'' );
my $q = 90;

sub _init {
	my $c = shift;
	$m = $c->model('Image');
	$init = $c->c_init();
	$id = $init->{'id'};
	$data = $init->{'data'};
	$files = $c->req->every_upload('files');
	$tmp_path_dir = $c->app->config->{'image'}->{'tmp_path_dir'};	
	$m && $files ? 1 : 0;
}

sub set {
	my $c = shift;
	$c->_init;
	#return $c->reply->not_found unless $c->_init;
	
	my ($data_original,$data) = ([],[]);

	# priduct_id
	unless( $id ){
		$c->app->log->warn('Not param product_id');
		return $c->render( json => { error => 'Not patam product_id' } );
	}	
	#
	# Origin 
	#
	my $info = $c->app->config->{'image'}->{'product'}->{'origin'} or do {
		$c->app->log->warn('image->product->origin not exists');
		return $c->render( json => { error => 'image->product->origin not exists' } );
	};
	
	if( my $res = $c->_info( 'origin', $info ) ){
		my $f_a = [];
		my $hash = {};
		for my $item ( @{$res} ) {
			$hash = {
				md5_hex => $item->{'md5_hex'},
				origin_name => $item->{'origin_name'},
				name => $item->{'name'},
				path => $item->{'path'},
				w => $info->{'max_w'},
				h => $info->{'max_h'},
				user_id => 1
			};
			my $res = $m->set( $hash );
			$hash->{'image_id'} = $res if $res;
			$hash->{'product_id'} = $id;
			push @{$f_a}, $hash;
			
		}
		push @{$data_original}, @{$f_a};
	}
	else{
		$c->app->log->error('Error');
	}
	
	for my $key ( grep{ $_ ne 'origin'} keys %{ $c->app->config->{'image'}->{'product'} } ) {
		my $info = $c->app->config->{'image'}->{'product'}->{$key} or do{
			$c->app->log->warn('image->product->'.$key.' not exists');
			next;
		};
		if( my $res = $c->_info_product( $key, $info, $data_original ) ){
			
			for my $item ( @{$res} ) {
				my $hash = {
					md5_hex => $item->{'md5_hex'},
					product_id => $item->{'product_id'},
					image_id => $item->{'image_id'},
					origin_name => $item->{'origin_name'},
					name => $item->{'name'},
					path => $item->{'path'},
					w => $info->{'max_w'},
					h => $info->{'max_h'},
					user_id => 1
				};
				
				my $res = $m->set_product($hash);				
			}			
			push @{$data}, @{$res};
		}
		else{
			$c->app->log->error('Error => '.$key);
		}
	}
	
	for my $file ( @{$files} ){
		my $name = $file->filename =~ s/[^\w\d\.]+/_/gr;
		my $tmp_file = "$tmp_path_dir/$name";
		$c->img_tmp_remove( $tmp_file );
	}
	
	my @arr = (@{$data}, @{$data_original});
	
	if( @arr ){
		$c->render( json => { success =>\1 , data => \@arr } );
	}
	else{
		$c->render( json => { failue =>\1 , message => 'Ошибка сервера'} );
	}	
}

sub list {
	my $c = shift;
	return 1;
}

sub get {
	my $c = shift;
	return $c->reply->not_found unless $c->_init;
	my %hash = ();
	my %filter = ();
	$filter{'w'} = $init->{'data'}->{'w'} if $init->{'data'}->{'w'};
	$filter{'h'} = $init->{'data'}->{'h'} if $init->{'data'}->{'h'};

	my $json = $m->product_list( \%filter );
	
	for my $item ( @{ $json->{'data'} } ) {
		$hash{ $item->{'image_id'} } = 1;
	}
	for my $id ( keys %hash ) {
		my $data = $m->get_origin( { image_id => $id } );
		push @{ $json->{'origin'} }, $data;
	}	

	$c->render( json => $json );
}

sub _info {
	my $c = shift;
	my $key = shift or do { return undef };

	my $info = shift or do{ return undef };
	my $up_file = [];
	
	my $path = exists $info->{'path'} ? $info->{'path'} : do {
		$c->app->log->warn('Error config image->product->'.$key.' not path to dir');
		return undef;
	};
	
	my $w = $info->{'max_w'} if exists $info->{'max_w'};
	my $h = $info->{'max_h'} if exists $info->{'max_h'};
	my $q = exists $info->{'q'} ? $info->{'q'} : $q;
		
	for my $file ( @{$files} ){
		my $name = $file->filename =~ s/[^\w\d\.]+/_/gr;
		my $tmp_file = "$tmp_path_dir/$name";
		$file->move_to( $tmp_file );
		
		if( $w || $h ){
			push @{$up_file}, $c->img_resize( $key, $tmp_file, $tmp_path_dir, $path, $name, $w, $h, $q  );
		}
		else{
			$c->app->log->warn('Error config image->product->origin not max_w or max_h');
			next;
		}		
	}
	return $up_file;
}

sub _info_product {
	my $c = shift;
	my $key = shift or do { return undef };
	my $info = shift or do{ return undef };
	my $files = shift or do{ return undef };
	my $up_file = [];
	
	my $path = exists $info->{'path'} ? $info->{'path'} : do {
		$c->app->log->warn('Error config image->product->'.$key.' not path to dir');
		return undef;
	};
	
	my $w = $info->{'max_w'} if exists $info->{'max_w'};
	my $h = $info->{'max_h'} if exists $info->{'max_h'};
	my $q = exists $info->{'q'} ? $info->{'q'} : $q;
		
	for my $file ( @{$files} ){
		my $name = $file->{'name'};
		my $tmp_file = $c->app->config->{'image'}->{'product'}->{'origin'}->{'path'} . "/" . $file->{'path'};
		
		if( $w || $h ){
			my $hash = $c->img_resize( $key, $tmp_file, $tmp_path_dir, $path, $name, $w, $h, $q  );
			$hash->{'image_id'} = $file->{'image_id'};
			$hash->{'product_id'} = $file->{'product_id'};
			push @{$up_file}, $hash;
		}
		else{
			$c->app->log->warn('Error config image->product->origin not max_w or max_h');
			next;
		}		
	}
	return $up_file;	
}
1;