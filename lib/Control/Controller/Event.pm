package Control::Controller::Event;
use Mojo::Base 'Mojolicious::Controller';
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

my ($m,$init) = ({},{});

sub _init {
  my $c = shift;
  $m = $c->model('Event');
  $init = $c->c_init();
  1;  
}

sub default {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();
  
  my $res = $m->list( $init->{'page'}, $init->{'rows'} );

  $c->stash->{ $c->config->{'project_name'} }->{'event'} = $res;
  $c->stash->{ $c->config->{'project_name'} }->{'event_pagination'} = $c->pagination( $init->{'page'} || 1, $res->{'count'}, { round => 1 });
  
  $c->stash->{ $c->config->{'project_name'} }->{'breadcrumbs'} = [
    {
      url => '/',
      title => 'На главную'
    },
    {
      url => '/events',
      title => 'Акции'
    }
  ];
  
  $c->stash->{ $c->config->{'project_name'} }->{'event_filter'} = {
    type => [],
    catagory => []
  };
  
  $c->render( template => 'pages/event' );
}

sub item {
  my $c = shift;
  return $c->reply->not_found unless $c->_init();
  my ($res,$res2) = ('','');
  my $path = $c->stash('path');
  if( $path ){
    $res = $m->get_event( { url_md5 => md5_hex($path) } );    
  }
  $c->stash->{ $c->config->{'project_name'} }->{'event_item'} = $res;
  $c->stash->{ $c->config->{'project_name'} }->{'breadcrumbs'} = [
    {
      url => '/',
      title => 'На главную'
    },
    {
      url => '/events',
      title => 'Акции'
    }
  ];
  
  #
  # Товары
  #
  if( %{ $res } && $res->{'sale_id'} ) {
    $res2 = $m->get_product2sale( $res->{'sale_id'}, $init->{'page'}, $init->{'rows'} );

    # Картинки
    $m = $c->model('Image');	
    for my $item ( @{$res2->{'data'}} ){		
      my $img = $m->product_list( {product_id => $item->{'product_id'} } );
      $item->{'images'} = $img->{'data'};
    }	
    
    # Характеристики
    $m = $c->model('Feature');	
    for my $item ( @{$res2->{'data'}} ){		
      my $feature = $m->get_v_product2feature( $item->{'product_id'} );
      $item->{'feature'} = $feature;
    }
    
    # Акции
    $m = $c->model('Event');
    for my $item ( @{$res2->{'data'}} ){
      my $sale = $m->product_is_sale( $item->{'product_id'} );
      if( $sale ){
        $item->{'sale'} = $sale;
        my $price = $m->get_product_price( $sale->{'sale_id'}, $item->{'product_id'} );
        if( $price ){
          $item->{'data'}->{'price'}->{'prev'} = $item->{'data'}->{'price'}->{'current'};
          $item->{'data'}->{'price'}->{'current'} = $price->{'price'};
          $item->{'data'}->{'price'}->{'percent'} = 100 - int( $item->{'data'}->{'price'}->{'current'} * 100 / $item->{'data'}->{'price'}->{'prev'});
        }
        #say Dumper( $item->{'product_id'}, $price , $item);
      }
    }
    
    $c->stash->{ $c->config->{'project_name'} }->{'products'} = $res2;
    $c->stash->{ $c->config->{'project_name'} }->{'products_pagination'} = $c->pagination( $init->{'page'} || 1, $res2->{'count'}, { round => 1 });
        
  }
  else{
    return $c->reply->not_found;
  }
  
  $c->render( template => 'pages/event/item' );  
}

1;
