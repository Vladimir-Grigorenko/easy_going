package Control::Controller::Compare;
use Mojo::Base 'Mojolicious::Controller';

sub _init {
  my $c = shift;
  my($m) = ('');
  $m = $c->model('default');
  $m->get_default_data( $c );
}

sub default {
  my $c = shift;
  $c->_init();
  $c->render(template => 'pages/compare');
}

1;