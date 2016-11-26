package Control::Plugin::Image;
use Mojo::Base 'Mojolicious::Plugin';
use Image::Resize;
use Image::Scale;
use Digest::MD5::File qw(dir_md5_hex file_md5_hex url_md5_hex);
use File::Path qw(make_path remove_tree);
use File::Copy;
use Data::Dumper;

sub register {
	my ($self,$app) = @_;
	
	$app->helper( img_resize => sub {
		my ($c, $key, $file_tmp, $tmp_path, $path, $name, $w, $h, $q) = @_;
		return undef unless ( $file_tmp && $tmp_path && $path && $name && $w && $h );
		my $rnd = time.int(rand(100));

		make_path($path, { chmod => 0777 } ) unless -d $path;
		
		my $image = Image::Resize->new( $file_tmp );
		$w = $image->width() > $w ? $w :  $image->width();
		$h = $image->height() > $h ? $h :  $image->height();
		my $gd = $image->resize( $w, $h );
		my $f = $tmp_path . "/" . $rnd;
		
		open(FH, '>', $f) or die $!;
			binmode(FH);
			print FH $gd->jpeg($q);
		close(FH);
		
		my $d = file_md5_hex( $f );
		$d =~/(..)(..)/i;
		my $new_path = "$path/$1/$2";
		my $new_local_path = "$1/$2";
		
		make_path($new_path, { chmod => 0777 } ) unless -d $new_path;
		$name =~s/\.\w+?$/\.jpg/i;
		
		my $new_f = "$new_path/$name";
		$new_local_path .= "/$name";
		
		copy($f, $new_f) or die $!;
		unlink( $f );
		{
			path => $new_local_path,
			origin_name => $name,
			name => $name,
			md5_hex => $d,
		}
	});
	
	# XS only file_tmp !!! not fh
	$app->helper( img_tmp_remove => sub {		
		my ($c, $file_tmp ) = @_;
		unlink( $file_tmp );
		1;
	});

	
	return 1;
}

1;