package Control::Model::Filter;
use Mojo::Base 'MojoX::Model';
use Data::Dumper;

my %filter = ( 'Бренд' => 3, 'Страна производитель' => 4, 'Размер' => 2, 'Цвет' => 1, 'Материал' => 5 );

sub get_filter2catalog {
    my $model = shift;
    my $data = shift or return undef; 
    my $db = $model->app->db;
    my $filters = {};
    
    for my $item ( keys %filter ){
        my $res = $db->resultset('VProduct2feature')->search({
            product_id => { IN => $data->{'product'} },
            feature_id => $filter{ $item }
        },
        {
            columns => [qw/feature_id title feature2value_id value/],
            group_by => [qw/feature2value_id/]
        });
        
        $res->result_class('DBIx::Class::ResultClass::HashRefInflator');  
        my @res = $res->all();
        my $int = int( scalar @res / 2 );
        my @part1 = (@res) [ 0 .. $int-1 ];
        my @part2 = (@res) [ $int .. scalar @res - 1 ];
        $filters->{ $item } = [ \@part1, \@part2 ] if @res;
    }
    
    return $filters;
}

1;