package Control::Controller::News;
use Mojo::Base 'Mojolicious::Controller';

sub default {
	my $c = shift;
	$c->list();
}

sub list {
	my $c = shift;
	$c->render(template => 'pages/news');
}

sub item {
	my $c = shift;
}
1;