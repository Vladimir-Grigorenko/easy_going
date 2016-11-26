package Control::Model::Event;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Data::Dumper;

sub get_event {
    my $model = shift;
    my $data = shift or do {
        return undef;
    };
    
    my $db = $model->app->db;
    my $h = {};
	my $res = $db->resultset('VSaleInfo')->find( $data );
    
	if( $res ){
		for my $key ( $res->columns ) {
			$h->{ $key } = $res->$key if defined $res->$key;
		}
		return $h;
	}
    
    return undef;
}

sub get_product2sale {
    my $model = shift;
    my $sale_id = shift;
    my $page = shift;
    my $rows = shift;
    my $db = $model->app->db;

	my $res = $db->resultset('VProduct2sale')->search(
        {
            sale_id => $sale_id
        },
        {
            rows => $rows,
            page => $page,
        }
    );  
	$res->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	
    my @res = $res->all();
	my $rs = $db->resultset('VProduct2sale')->search(
		{ sale_id => $sale_id },
		{
			select => [
				{ count => 'sale_id' }
			],
			as => [ 'count' ]
		}
	);
	
	my $count = $rs->next->get_column('count');

	my @products = ();
	for my $item ( @res ){
        my $m = $model->app->model('Product');
		my $data = $m->get_v_product_info({ category_id => $item->{'category_id'}, product_id => $item->{'product_id'} });
		$item->{'data'} = $data if %{$data};
		push @products, $item->{'product_id'} if $data->{'quantity'};
	}
	
    return {
        success => \1,
        count => $count,
        page => $page,
        rows => $rows,
        data => \@res
    };    
}

sub list {
	my ($model, $page, $rows ) = @_;
	my $db = $model->app->db;	
	
	my $res = $db->resultset('VSaleInfo')->search( undef,{
		rows => $rows,
		page => $page,
		#order_by => ['sort']
	});  
	$res->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $res->all();
	
	my $rs = $db->resultset('VSaleInfo')->search(
		undef,
		{
			select => [
				{ count => 'sale_id' }
			],
			as => [ 'count' ]
		}
	);
	
	my $count = $rs->next->get_column('count');  
	
    return {
        success => \1,
        count => $count,
        page => $page,
        rows => $rows,
        data => \@res
    };
}

sub get_product2event {
    my $model = shift;
    my $sale_id = shift;
    my $attr = shift;
    my $db = $model->app->db;
    my ($res, $data, @res) = ([],undef,());
    
    if( $sale_id ){
        $data = {
            sale_id => $sale_id 
        };
    }

    $res = $db->resultset('VProduct2sale')->search($data,{
		rows => $attr->{'rows'},
		page => $attr->{'page'}        
    });
    
    $res->result_class('DBIx::Class::ResultClass::HashRefInflator');  
    @res = $res->all();        
    
	my $rs = $db->resultset('VProduct2sale')->search(
		$data,
		{
			columns => [ qw/product_id/ ],
			distinct => 1
		}
	);
	  
	my $count = $rs->count;
    
    return {
        success =>\1,
        count => $count,
        page => $attr->{'page'},
        rows => $attr->{'rows'},
        data=>\@res,
    };
}

sub product_is_sale {
    my $model = shift;
    my $product_id = shift;
    my $db = $model->app->db; 
    my $h = {};

	my $rs = $db->resultset('VProduct2sale')->search(
		{ product_id => $product_id },
		{
			columns => [ qw/product_id sale_id/ ],
		}
	);
    $rs->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $rs->all();
	  
	my $count = $rs->count;
    if( $count ){
        my $res = $db->resultset('VSaleInfo')->find( {
            sale_id => $res[0]->{'sale_id'}
        });
    
        if( $res ){
            for my $key ( $res->columns ) {
                $h->{ $key } = $res->$key if defined $res->$key;
            }
        }
    }
    return $count ? $h : undef;
}

sub get_product_price {
    my $model = shift;
    my $sale_id = shift;
    my $product_id = shift;
    my $db = $model->app->db; 
    my $h = {};
    my $res = $db->resultset('Product2sale')->find( {
        sale_id => $sale_id,
        product_id => $product_id
    });

    if( $res ){
        for my $key ( $res->columns ) {
            $h->{ $key } = $res->$key if defined $res->$key;
        }
    }
    $h->{'price'} = int($h->{'price'}/100) if $h->{'price'};
    $h->{'price_after'} = int($h->{'price_after'}/100) if $h->{'price_after'};            
    
    return %{ $h  } ? $h : undef;
}
1;