package Control::Model::User;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Digest::MD5 qw(md5_hex);
use Storable qw(freeze thaw);
use Data::Dumper;

my ($r,$count,$rs,$exception, $id) = ('',0,0,'');

sub _init {
	my $model = shift;
	1;
}

sub get {
	my ($model, $uid) = @_;
	my $db = $model->app->db;
	
	$r = $db->resultset('VUserInfo')->find( { user_id => $uid }  );  
	my %h = ();
	for my $key ( $r ? $r->columns : () ) {
		$h{$key} = $r->$key;
	}
	\%h;
}

sub set {
	my ( $model, $data ) = @_;
	my (@data, @res, %data) = ((),(),());
	my $db = $model->app->db;
	@data = @{ $data };
	
	$db->storage->txn_begin();
	try {
		for my $item ( @data ) {
			next unless ref $item eq 'HASH';      
			unless ( exists $item->{'mail'} ) {
				push @res, { item => $item,  message => "mail not exists"};
				next; 
			}
			# email valid
			unless( $model->app->mailrfc( $item->{'mail'} ) ){
				push @res, { item => $item,  message => "mail not valid"};
				next;         
			}
			$r = $db->resultset('User')->find( { mail => $item->{'mail'} } );
			if ($r) {
				push @res, { mail => $item->{'mail'}, message => "exists"};
				next;
			}
			%data =  map { $_ => $item->{$_} } grep { $_ !~ /id/i } keys %{ $item };
		  
			my $res = $db->resultset('User')->create( \%data );
			my $id = $res->user_id;
			push @res, { id => $id, message => "create"};
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
	my (@data, @res) = ((),());
	my $db = $model->app->db;
	@data = @{ $data };
  
	$db->storage->txn_begin();
	try {
		for my $item ( @data ) {
			next unless ref $item eq 'HASH';
			$r = $db->resultset('User')->find( { user_id => $item->{'uid'} }  );
			unless ($r) {
				push @res, { id => $item->{'uid'}, message => "not exists"};
				next;
			}
			for my $key ( grep { $_ ne 'uid' || $_ ne 'access_delete' } keys %{$item} ) {
				if( $r->has_column( $key ) ){
					$r->$key( $item->{$key} );
				}
			}
			if ( $r->has_column('date_update') ) {
				$r->date_update(\'NOW()');
			}	  
			$r->update;
			push @res, { id => $item->{'uid'}, message => "update"};
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
	my (@data, @res) = ((),());
	my $db = $model->app->db;
	@data = @{ $data };
  
	$db->storage->txn_begin();
	try {
		for my $id ( @data ) {
			$r = $db->resultset('User')->find( { user_id => $id }  );
			unless ($r) {
				push @res, { id => $id, message => "not exists"};
				next;
			}
			if ( $r->access_delete ) {
				$r->delete;
				push @res, { id => $id, message => "remove"};
			}
			else{
				push @res, { id => $id, message => "access denied"};
			}	              
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
	$r = $db->resultset('User')->search( undef,{
		rows => $rows,
		page => $page
	});  
	$r->result_class('DBIx::Class::ResultClass::HashRefInflator');  
	my @res = $r->all();
  
	$rs = $db->resultset('User')->search(
		undef,
		{
			select => [
				{ count => 'user_id' }
			],
			as => [ 'count' ]
		}
	);
  
	$count = $rs->next->get_column('count');  
	{ success =>\1, count=> $count, page => $page, rows => $rows,  data=>\@res };
}

sub login {
	my ($model, $mail) = @_;
	my $db = $model->app->db;
	my $h = {} ;
	$r = $db->resultset('User')->find( { mail => $mail } );
	if( $r && $r->access ) {
		$h->{'user_id'} = $r->user_id;		
		my $admin = $db->resultset('User2admin')->find( { user_id => $r->user_id } );
		if( $admin && $admin->access_id == 1 ){
			$h->{'is_admin'} = 1;
			$h->{'user_admin_group_id'} = $admin->user_admin_group_id;
		}
		return $h;
	}
	return undef;
}

sub confirm_login_mail {
	my ($model, $user, $mail, $attr ) = @_;
	my $db = $model->app->db;
	$db->storage->txn_begin();
	try {	
		$r = $db->resultset('User2session')->update_or_create({
			session => $user->{'sid'},
			user_id => $user->{'user_id'},
			
			user_agent_md5 => md5_hex( scalar $attr->{'user_agent'} ),
			user_agent => $attr->{'user_agent'},
			ip => $attr->{'ip'}
		});
		$db->storage->txn_commit();
		return $r;
	}
	catch{
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	};
}

sub login_confirm {
	my ($model,$code) = @_;
	my $db = $model->app->db;
	my $h = {};
	$db->storage->txn_begin();
	try {		
		$r = $db->resultset('User2session')->find({ session => $code });
		if( $r ){
			$r->confirm(1);
			$r->update;
			my $u = $db->resultset('User')->find({ user_id => $r->user_id });
			for my $key ( $u->columns ) {
				$h->{ $key } = $u->$key;
			}
			$h->{'code'} = $code;
			if( $h->{'access'} ){
				my $a = $db->resultset('User2admin')->find({ user_id => $h->{'user_id'} });
				if( $a ){
					for my $key ( $a->columns ) {
						$h->{ $key } = $a->$key;
					}
				}
				return $h;
			}
			else{
				return undef, 'Доступ закрыт.';
			}
			$db->storage->txn_commit();
		}
		else{
			return undef,'Код недействителен';
		}
	}
	catch{
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	};		

}

sub get_session2serialize {
	my ($model, $data) = @_;
	my $db = $model->app->db;
	my $r = $db->resultset('Session2serialize')->find( {
		session => $data->{'session'},
		name => $data->{'name'}
	} );
	my %h = ();
	for my $key ( $r ? $r->columns : () ) {
		$h{$key} = $r->$key;
	}
	$h{'data'} = thaw $h{'data'};
	$h{'data'} ? $h{'data'} : {};
}

sub set_session2serialize {
	my ($model, $data) = @_;
	my $db = $model->app->db;
	$db->storage->txn_begin();
	$data->{'data'} = freeze $data->{'data'};
	try {
		my $r = $db->resultset('Session2serialize')->find( {
			session => $data->{'session'},
			name => $data->{'name'}
		});
		if( $r ){
			$r->data( $data->{'data'} );
			$r->date_update(\'NOW()');
			$r->update();
		}
		else{
			$r = $db->resultset('Session2serialize')->create({
				session => $data->{'session'},
				name => $data->{'name'},
				data => $data->{'data'}
			});
		}
		$db->storage->txn_commit();
		my %h = ();
		for my $key ( $r ? $r->columns : () ) {
			$h{$key} = $r->$key;
		}
		$h{'data'} = thaw $h{'data'};
		return \%h;
	}
	catch{
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;		
	};	
}

1;