use v5.18;
use warnings;
use Schema;
use Data::Dumper;


my $db = Schema->connect( 'dbi:mysql:dbname=hilt', 'root', '', {
      quote_names => 1,
      mysql_enable_utf8 => 1,
});


my $r = $db->resultset('Category')->search( {
					parent_id => 0,
					title => 'Одежда и обувь',
					url => 'clothing-and-shoes'
			},{
					select => [
						{ count => 'category_id' }
					],
					as => [ 'count' ]
                  });

my $count = $r->next->get_column('count');