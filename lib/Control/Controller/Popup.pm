package Control::Controller::Popup;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ($db,$init,$item,$format) = ('',{},'','html');
sub _init {
	my $c = shift;
	$item = $c->stash('item');
	$format = $c->stash('format') if $c->stash('format'); 
	$init = $c->c_init( $c );
	$item ? 1 : 0;
};


sub item {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	if( $init->{'data'}->{'cart_add'} ){
		$c->add2session2cart({
			product_id => $init->{'data'}->{'product_id'},
			sub_value => $init->{'data'}->{'sub_value'},
			quantity => $init->{'data'}->{'quantity'}
		});
	}

	if( $init->{'data'}->{'cart_remove'} ){
		$c->remove2session2cart({
			product_id => $init->{'data'}->{'product_id'},
			sub_value => $init->{'data'}->{'sub_value'}
		});
	}
	
	$c->stash->{'user'}->{'cart'} = $c->cart_list;
		
	$c->respond_to(
		json => sub {
			$c->render( json => {
				res => $c->stash->{'cart'},
				success => \1
			})
		},
		html => {
			template => 'pages/popup/' . $item
		}
	);
}

sub _cart_add {
	my $c = shift;
	my $cart = $c->stash->{'user'}->{'cart'} || {};
	$cart->{ $init->{'data'}->{'product_id'} }->{ $init->{'data'}->{'sub_value'} || 'none' } = $init->{'data'}->{'quantity'};
	$c->add2session2cart( $cart );
	1;
}

1;