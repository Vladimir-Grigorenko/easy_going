package Control::Model::User;
use Mojo::Base 'MojoX::Model';
use Try::Tiny;
use Digest::MD5 qw(md5_hex);
use Data::Dumper;

my ($r,$count,$rs,$exception, $id) = ('',0,0,'');

sub _init {
	my $model = shift;
	1;
}

sub get {
	my ($model, $db, $uid) = @_;
	
	$r = $db->resultset('User')->find( { user_id => $uid }  );  
	my %h = ();
	for my $key ( $r ? $r->columns : () ) {
		$h{$key} = $r->$key;
	}
	\%h;
}

sub set {
	my ( $model, $c, $db, $data ) = @_;
	my (@data, @res, %data) = ((),(),());  
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
			unless( $c->mailrfc( $item->{'mail'} ) ){
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
	my ( $model, $db, $data ) = @_;
	my (@data, @res) = ((),());  
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
	my ( $model, $db, $data ) = @_;
	my (@data, @res) = ((),());  
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
	my ($model, $db, $page, $rows ) = @_;
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
	my ($model, $db, $c, $mail ) = @_;
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
	my ($model, $db, $c, $user, $mail ) = @_;
	$db->storage->txn_begin();
	try {	
		$r = $db->resultset('User2session')->update_or_create({
			session => $user->{'sid'},
			user_id => $user->{'user_id'},
			user_agent_md5 => md5_hex( scalar $c->req->headers->user_agent ),
			user_agent => $c->req->headers->user_agent,
			ip => $c->remote_addr
		});
		$db->storage->txn_commit();
		return 1;
	}
	catch{
		my $err = $_;
		$db->storage->txn_rollback();
		return undef, $err;
	};
	$r;
}

sub login_confirm {
	my ($model, $db, $c, $code ) = @_;
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

1;