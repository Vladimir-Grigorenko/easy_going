package Control::Controller::Image;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

sub get {
	my $c = shift;
	my $path = $c->app->config->{'path'}->{'photo'} . "/" . $c->stash('item') .".".$c->stash('format');
	if( -f $path ){
		$c->reply->asset( Mojo::Asset::File->new( path => $path ) );
	}
	else{
		$c->reply->not_found;
	}	
}

1;