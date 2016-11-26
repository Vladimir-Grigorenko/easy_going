package Control::Controller::Admin::Pages;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ($init) = ('');
sub _init {
	my $c = shift;
	$init = $c->c_init();
	1;
}

sub index {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	my $u = $c->stash('user');
	$c->app->log->info("admin in main page: ".$u->{'first_name'}." ".$u->{'last_name'})
		if $u && $u->{'user_id'};
	$c->render( template => 'admin/index');
}

1;