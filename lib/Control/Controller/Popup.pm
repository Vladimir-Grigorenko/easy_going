package Control::Controller::Popup;
use Mojo::Base 'Mojolicious::Controller';

my ($db,$init,$item,$format) = ('',{},'','html');
sub _init {
	my $c = shift;
	$db = $c->db;
	$item = $c->stash('item');
	$format = $c->stash('format') if $c->stash('format'); 
	$init = $c->c_init( $c );
	$item ? 1 : 0;
};


sub item {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	$c->render( template => 'pages/popup/' . $item, format => $format  );
}