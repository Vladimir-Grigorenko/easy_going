package Control::Model::Feature;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Data::Dumper;

my ($r,$count,$rs,$exception,$id,@trim) = ('',0,0,'',());

sub _init {
  my $model = shift;
  1;
}

sub get {
  my ($model, $data) = @_;
  my $db = $model->app->db;  
  $r = $db->resultset('Feature')->find( $data );  
  my %h = ();
  for my $key ( $r ? $r->columns : () ) {
    $h{$key} = $r->$key;
  }
  %h ? \%h : undef;
}

sub set {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my %columns = map{ $_ => 1 } $db->source("Feature")->columns;
  my ($feature,$value) = ( {},'' );
  
  for my $key ( keys %{ $data } ) {
    my $find = 0;
    if( !$find && exists $columns{$key} && $key !~/^(feature_id)$/i ) {
      $feature->{ $key } = $data->{ $key };
    }    
  }
  
  $db->storage->txn_begin();
  try {			
    my %h = ();
    my $res = $db->resultset('Feature')->create( $feature );
    my $id = $res->feature_id;    
    %h = map { $_ => $res->$_ } keys %columns;
    $db->storage->txn_commit();
    return \%h;
  }
  catch {
    my $err = $_;
    $db->storage->txn_rollback();
    return undef, $err;
  };
  
}

sub update {
  my ( $model, $feature_id, $data ) = @_;
  my $db = $model->app->db;
  my $feature = {};  
	
  $db->storage->txn_begin();
  
  try {			    
    $r = $db->resultset('Feature')->find( { feature_id => $feature_id }  );
    if ($r) {        
			for my $key ( grep { $_ !~ /^(feature_id|data_create)$/i } keys %{ $feature } ) {
				if( $r->has_column( $key ) ){
					$r->$key( $feature->{$key} );
				}
			}
			if ( $r->has_column('date_update') ) {
				$r->date_update(\'NOW()');
			}	  
      $r->update;
    }
    $db->storage->txn_commit();
    return $feature;    
  
  }
  catch {
    my $err = $_;
    $db->storage->txn_rollback();
    return undef, $err;
  };
}

sub remove {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my (@data, @res) = ((),());  
  @data = @{ $data };
  
  $db->storage->txn_begin();
  try {
    for my $id ( @data ) {
      my $res = $db->resultset('Feature')->find( { feature_id => $id }  );
      unless ( $res ) {
        push @res, { feature_id => $id, message => "not exists"};
        next;
      }
			$res->delete;
			push @res, { feature_id => $id, message => "remove"};
    }
    $db->storage->txn_commit();
    return \@res;    
  }
  catch {
    my $err = $_;
    $db->storage->txn_rollback();
    return undef, $err;
  };  
}

sub list {
  my ($model, $page, $rows ) = @_;
  my $db = $model->app->db;
  my $res = $db->resultset('Feature')->search( undef,{
    rows => $rows,
    page => $page
  });  
  $res->result_class('DBIx::Class::ResultClass::HashRefInflator');  
  my @res = $res->all();
  
  $rs = $db->resultset('Feature')->search(
    undef,
    {
      select => [
        { count => 'feature_id' }
      ],
      as => [ 'count' ]
    }
  );
  
  $count = $rs->next->get_column('count');  
  { success =>\1, count=> $count, page => $page, rows => $rows,  data=>\@res };
}


sub set_feature2product {
  my ( $model, $product_id, $feature ) = @_;
  my $db = $model->app->db;
  my ($data, $res, $res2,$err2) = ([],undef,undef);
  my $return = {
    product_id => $product_id
  };
  
  #
  # Название характеристики
  #
  for my $title ( keys %{ $feature } ){
    $res = $model->get( { title => $title } );
    if( $res ){
      $res->{'value'} = $feature->{ $title }; 
      push @{$data}, $res;
    }
    else{
      $res2 = $model->set( { title => $title, user_id => 1 } );
      if ( $res2 ) {
        $res2->{'value'} = $feature->{ $title }; 
        push @{$data}, $res2;
      }
    }
  } # for
  
  #
  # Значение характеристики
  #
  for my $item ( @{ $data } ){
    my %feature2value = ();
    
    if( $item->{'value'} && ref $item->{'value'} eq "HASH" ){    
      %feature2value = %{ $item->{'value'} };     
    }
    else{
      %feature2value = ( $item->{'value'} => '' );
    }
    
    #
    # $value -> sub_value table product2feature2value
    #
    while ( my ($key,$value) = each %feature2value ) {      
      
      my $res = $model->get_feature2value({
        feature_id => $item->{'feature_id'},
        value => $key
      });
      
      unless ( $res ) {
        $res = $model->set_feature2value( {
          feature_id => $item->{'feature_id'},
          value => $key
        } );
      }
            
      #
      # Связка с продуктом + дополнительное значение
      #
      my $h_data = {
          product_id => $product_id,
          feature2value_id => $res->{'feature2value_id'}
      };

      my ($res2,$err) = $model->get_product2feature2value( $h_data );
      
      if( $res2 && $value ) {
        $res2 = $model->update_product2feature2value(
          $res2->{'product2feature2value_id'},
          $value
        );
      }
      else{
        $h_data->{'sub_value'} = $value if $value;
        ($res2,$err) = $model->set_product2feature2value(
          $h_data,
        );
      }
            
      
    } # while
    
    push @{ $return->{'feature'} }, { data => $item, sub => $res2 };
    
  } # for

  return $return;
}

sub get_product2feature2value {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my ($columns, $product2feature2value ) = ([],{});
  my %h = ();

  @{$columns} = $db->source('Product2feature2value')->columns;
  
  for my $item ( @{$columns} ) {
    $product2feature2value->{ $item } = $data->{ $item }
      if $data->{ $item };
  }
    
  my $res = $db->resultset('Product2feature2value')->find( $product2feature2value );
  if( $res ) {
    %h = map { $_ => $res->$_ } @{$columns};
  }
  
  return %h ? \%h : undef;   
}

sub set_product2feature2value {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my ($columns, $product2feature2value ) = ([],{});  

  @{$columns} = $db->source('Product2feature2value')->columns;
  
  for my $item ( @{$columns} ) {
    $product2feature2value->{ $item } = $data->{ $item }
      if $data->{ $item };
  }
  
  $db->storage->txn_begin();
  try {
    my %h = ();
    my $res = $db->resultset('Product2feature2value')->create( $product2feature2value );
    %h = map { $_ => $res->$_ } @{$columns};
    $db->storage->txn_commit();
    return \%h;
  }
  catch {
    my $err = $_;
    $db->storage->txn_rollback();
    return undef, $err;
  };	
}

sub update_product2feature2value {
  my ( $model, $product2feature2value_id, $sub_value ) = @_;
  my $db = $model->app->db;
  
  my $res = $db->resultset("Product2feature2value")->find( {
    product2feature2value_id => $product2feature2value_id
  } );

  if( $res ){
    $db->storage->txn_begin();  
    try {
      $res->sub_value( $sub_value );
      if ( $res->has_column('date_update') ) {
        $res->date_update(\'NOW()');
      }	      
      $res->update();
      $db->storage->txn_commit();
      return 1;
    }
    catch {
      my $err = $_;
      $db->storage->txn_rollback();
      return undef, $err;      
    };    
  }
  else{
    return undef, 'dont find product2feature2value_id => ' . $product2feature2value_id;
  }
}


sub set_feature2value {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my ($columns, $feature2value ) = ([],{});  
  
  @{$columns} = $db->source('Feature2value')->columns;
  
  for my $item ( grep { $_ !~ /^(feature2value_id)$/i } @{$columns} ) {
    $feature2value->{ $item } = $data->{ $item }
      if $data->{ $item };
  }
  
  $db->storage->txn_begin();
  try {
    my %h = ();
    my $res = $db->resultset('Feature2value')->create( $feature2value );
    %h = map { $_ => $res->$_ } @{$columns};
    $db->storage->txn_commit();
    return \%h;    
  }
  catch {
    my $err = $_;
    $db->storage->txn_rollback();
    return undef, $err;
  };
	
}

sub get_feature2value {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my ($columns, $feature2value ) = ([],{});
  my %h = ();

  @{$columns} = $db->source('Feature2value')->columns;
  
  for my $item ( @{$columns} ) {
    $feature2value->{ $item } = $data->{ $item }
      if $data->{ $item };
  }
    
  my $res_rs = $db->resultset('Feature2value')->search( $feature2value );
  my $res = $res_rs->next;
  if( $res ) {
    %h = map { $_ => $res->$_ } @{$columns};
  }
  
  return %h ? \%h : undef;  
}


sub update_feature2value {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my ($columns, $feature2value ) = ([],{});
  my %h = ();
  
  @{$columns} = $db->source('Feature2value')->columns;

  my $res = $db->resultset("Feature2value")->find( {
    feature2value_id => $data->{ 'feature2value_id' }
  });

  if( $res ){

    $db->storage->txn_begin();  
    try {
      for my $item ( grep { $_ !~ /feature2value_id/i } @{$columns} ){
        $res->$item( $data->{ $item } );
      }
      if ( $res->has_column('date_update') ) {
        $res->date_update(\'NOW()');
      }	      
      $res->update();
      $db->storage->txn_commit();
      return $data;
    }
    catch {
      my $err = $_;
      $db->storage->txn_rollback();
      return undef, $err;      
    };
    
  }
}

sub remove_feature2value {
  my ( $model, $data ) = @_;
  my $db = $model->app->db;
  my (@data, @res, %data) = ((),(),());
}


sub get_v_product2feature {
  my ( $model, $product_id ) = @_;
  my $feature = {};
  my $db = $model->app->db;
  my $res = $db->resultset('VProduct2feature')->search({
    product_id => $product_id
  });
  $res->result_class('DBIx::Class::ResultClass::HashRefInflator');  
  my @res = $res->all();
  
  for my $item ( @res ){
    push @{ $feature->{ $item->{'title'} } },
      {
        value => $item->{'value'},
        sub_value => $item->{'sub_value'}
      };
  }
  
  return $feature;
}
1;