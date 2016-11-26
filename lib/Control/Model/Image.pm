package Control::Model::Image;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Data::Dumper;

my ($r,$count,$rs,$exception, $id) = ('',0,0,'');

sub _init {
	my $model = shift;
	1;
}

sub set {
	my ($model, $data) = @_;
	return undef unless $data && %{$data};
	my $db = $model->app->db;
	
	try {
		my $r = $db->resultset('Image')->find({ md5_hex => $data->{'md5_hex'} });
		unless( $r ){
			my $res = $db->resultset('Image')->create( $data );
			return $res->image_id;
		}
		else{
			return $r->image_id;
		}
	}
	catch {
		my $err = $_;
		return undef, $err;
	};
}

sub set_product {
	my ($model, $data) = @_;	
	return undef unless $data && %{$data};
	my $db = $model->app->db;

	try {
		my $r = $db->resultset('Image2product')->find({ md5_hex => $data->{'md5_hex'}, path => $data->{'path'} });
		
		unless( $r ){
			
			my $res = $db->resultset('Image2product')->create( $data );
			if ( $res ) {
				return $res->image2product_id;
			}
		}
		else{
			return $r->image2product_id;
		}
	}
	catch {
		my $err = $_;
		$model->app->log->error( $err );
		return undef, $err;
	};
	
}

# IN { image_id => \d+}
sub get_origin {
	my ($model, $filter ) = @_;
	my $db = $model->app->db;
	my $r = $db->resultset('Image')->find( $filter );
	my $h = {};
	for my $key ( $r->columns ) {
		$h->{ $key } = $r->$key;
	}
	$h->{'path'} = "/origin/" . $h->{'path'};
	$h->{'url_path'} = "/simg" . $h->{'path'};	
	return $h;
}

sub get_product_image {
	my ($model, $filter ) = @_;
	my $db = $model->app->db;
	my $r = $db->resultset('Image2product')->search( $filter );
	my $h = {};

	$r->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $r->all();
	for my $item ( @res ) {
		$item->{'path'} = "/" . $item->{'w'} . "_" . $item->{'h'} . "/" . $item ->{'path'};
		$item->{'url_path'} = "/simg" . $item->{'path'};	
	}	
	return \@res;
}

sub get_all_photo {
	my ($model, $filter ) = @_;
	return undef unless $filter->{'product_id'};
	my $h = {};
	my $db = $model->app->db;
	my $r = $db->resultset('Image2product')->search( $filter, {
		group_by => [qw/image_id/],
		order_by => [qw/image_id/]
	} );
	$r->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $r->all();
	
	return \@res;	
}
1;