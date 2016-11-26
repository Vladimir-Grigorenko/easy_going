package Control::Model::Category;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Data::Dumper;

my ($r,$count,$rs,$exception, $id) = ('',0,0,'');

sub _init {
	my $model = shift;
	1;
}

sub find {
	my ($model, $filter) = @_;
	my $db = $model->app->db;
	$r = $db->resultset('Category')->search( $filter );
	$r->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $r->all();
	return \@res;
}

sub get {
	my ($model, $cid) = @_;
	my $db = $model->app->db;
	
	$r = $db->resultset('Category')->find( { category_id => $cid }  );  
	my %h = ();
	for my $key ( $r ? $r->columns : () ) {
		$h{$key} = $r->$key;
	}
	\%h;					
}

sub set {
	my ( $model, $data ) = @_;
	my $db = $model->app->db;	
	my (@data, @res, %data) = ((),(),());  
	@data = @{ $data };

	$db->storage->txn_begin();
	try {
		for my $item ( @data ) {
			next unless ref $item eq 'HASH';      
			unless ( exists $item->{'url'} ) {
				push @res, { item => $item,  message => "url not exists"};
				next; 
			}
			
			$r = $db->resultset('Category')->search( {
					parent_id => $item->{'parent_id'},
					title => $item->{'title'},
					url => $item->{'url'}
				}, {
					columns => qw(category_id)
				}
			);
						
			if ( my $cd = $r->next  ) {
				$id = $cd->get_column('category_id');				
				push @res, { category_id => $id, url => $item->{'url'}, message => "exists"};
				next;
			}
	
			%data =  map { $_ => $item->{$_} } grep { $_ !~ /category_id/i } keys %{ $item };
			
			my $res = $db->resultset('Category')->create( \%data );
			my $id = $res->category_id;
			push @res, { category_id => $id, message => "create"};
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

sub update {
	my ( $model, $data ) = @_;
	my $db = $model->app->db;	
	my (@data, @res) = ((),());  
	@data = @{ $data };
	
	$db->storage->txn_begin();
	try {
		for my $item ( @data ) {
			next unless ref $item eq 'HASH';
			$r = $db->resultset('Category')->find( { category_id => $item->{'catagory_id'} }  );
			unless ($r) {
				push @res, { category_id => $item->{'category_id'}, message => "not exists"};
				next;
			}
			for my $key ( grep { $_ ne 'category_id' } keys %{$item} ) {
				if( $r->has_column( $key ) ){
					$r->$key( $item->{$key} );
				}
			}
			if ( $r->has_column('date_update') ) {
				$r->date_update(\'NOW()');
			}	  
			$r->update;
			push @res, { category_id => $item->{'category_id'}, message => "update"};
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

sub remove {
	my ( $model, $data ) = @_;
	my $db = $model->app->db;	
	my (@data, @res) = ((),());  
	@data = @{ $data };
	
	$db->storage->txn_begin();
	try {
		for my $id ( @data ) {
			$r = $db->resultset('Category')->find( { category_id => $id }  );
			unless ($r) {
				push @res, { category_id => $id, message => "not exists"};
				next;
			}
			$r->delete;
			push @res, { category_id => $id, message => "remove"};
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
	
	$r = $db->resultset('Category')->search( undef,{
		rows => $rows,
		page => $page,
		order_by => ['sort']
	});  
	$r->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $r->all();
	
	$rs = $db->resultset('Category')->search(
		undef,
		{
			select => [
				{ count => 'category_id' }
			],
			as => [ 'count' ]
		}
	);
	
	$count = $rs->next->get_column('count');  
	{ success =>\1, count=> $count, page => $page, rows => $rows,  data=>\@res };
}

1;