package Control::Controller::Api::User;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;

my ( $m, $db, $page, $rows, $id, $data, $init ) = ( '', '', 0, 0, 0, [], {} );

sub _init {
	my $c = shift;
	$m = $c->model('user');
	$init = $c->c_init();
	$db = $c->db;
	$page = $init->{'page'};
	$rows = $init->{'rows'};
	$id = $init->{'id'};
	$data = $init->{'data'};
	$m && $db ? 1 : 0;
}

sub get {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();  
	return $c->reply->not_found unless $id;
	
	my $h = $m->get( $db, $id );
	
	$c->render( json => $h );
}

sub update {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->render( json => { failue => \1, message => 'Нет данных' } ) unless $data;
	return $c->render( json => { failue => \1, message => 'Неправильная структура json' } ) if ref $data ne 'ARRAY';
	
	my ( $h, $error ) = $m->update( $db, $data );  
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
}

sub set {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->render( json => { failue => \1, message => 'Нет данных' } ) unless $data;
	return $c->render( json => { failue => \1, message => 'Неправильная структура json' } ) if ref $data ne 'ARRAY';

	
	my ( $h, $error ) = $m->set( $c, $db, $data );
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );  
}

sub remove {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->render( json => { failue => \1, message => 'Нет данных' } ) unless $data;
	return $c->render( json => { failue => \1, message => 'Неправильная структура json' } ) if ref $data ne 'ARRAY';

	my ( $h, $error ) = $m->remove( $db, $data );
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
}

sub list {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();	
	$c->render( json => $m->list( $db, $page, $rows ) );  
}

sub login {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->render( json => { failue => \1, message => 'Нет данных' } ) unless $data;
	return $c->render( json => { failue => \1, message => 'Не все данные' } ) unless $data->{'mail'};
	return $c->render( json => { failue => \1, message => 'Проверьте написание Вашего E-mail...' } ) unless $c->mailrfc( $data->{'mail'} );	
	
	my $h = $c->session( $c->app->config->{'session'}->{'cookie_name'} );	
	
	my($u,$err) = $m->login( $db, $c, $data->{'mail'} );	
	%{$u} = ( %{$h}, %{$u} ) if $u && %{$u};
	
	if( $u && %{$u} && $u->{'user_id'} ){
		
		my ($r, $err) = $m->confirm_login_mail( $db, $c, $u, $data->{'mail'} );
		if( $r ){
			$c->mail( {
				to => $data->{'mail'} ,
				subject => 'HILT - авторизация',
				mess=> 'Для входа в личный кабинет, перейдите по ссылке: https://127.0.0.1/login/confirm?code='.$u->{'sid'}
			});	
		}
		else{
			return $c->render( json => { failue => \1, message => $err } );
		}
	}
	else{
		return $c->render( json => { failue => \1, message => 'Вы не зарегистрированы.' } );
	}
	$c->render( json => $err ? { failue => \1, message => $err } : { success=> \1 , message => 'Авторизационное письмо ушло на Ваш E-mail.'} );
}

sub login_confirm {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	return $c->render( json => { failue => \1, message => 'Нет параметров' } ) unless $data && $data->{'code'};
	
	my $h = $c->session( $c->app->config->{'session'}->{'cookie_name'} );
	my($u,$err) = $m->login_confirm( $db, $c, $data->{'code'} );

	if( $u && %{$u} ){
		
		my %all = ( %{$h}, %{$u} );
		$u->{'sid'} = $h->{'sid'};
		$u->{'csrf'} = $h->{'csrf'};
		say Dumper('confirm',$u);
		$c->session( { $c->app->config->{'session'}->{'cookie_name'} => $u } );

	}
	
	$c->render( json => $u ? { success=> \1, message => $u } :  { failue => \1, message => $err } );	
}

sub logout {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();	
	$c->session( expires => 1 );
	
	$c->render( json => { success=> \1 } );
}

sub confirm_register {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	$c->render( json => { success=> \1 } );		
}

1;