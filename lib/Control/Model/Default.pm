package Control::Model::Default;
use Mojo::Base 'MojoX::Model';

sub get_default_data {
  my $self = shift;
  my $c = shift or do {
	return 0;
  };
  
  $c->stash({
	  system => {
		  url_for => $c->url_for->to_abs,
	  },
	  site => {
		  title => 'HILT - супермаркет товаров со скидками'
	  }
  });
  
  return 1;
}


1;