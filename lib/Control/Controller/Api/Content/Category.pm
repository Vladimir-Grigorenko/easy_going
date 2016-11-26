package Control::Controller::Api::Content::Category;
use Mojo::Base 'Mojolicious::Controller';
use Data::Dumper;
use Mojo::JSON qw(decode_json encode_json);

my ($m,$db,$page,$rows,$id, $init) = ('','', 1, 20, 0,'');
my $dom = '';

sub _init {
	my $c = shift;
	$m = $c->model('Category');
	$init = $c->c_init();
	1;
}

sub get {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();  
	return $c->reply->not_found unless $init->{'id'};
	
	my $h = $m->get( $id );	
	$c->render( json => $h );
}

sub update {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
		
	unless ( $init->{'data'}  ) {
		return $c->render( json => { failue => \1, message => 'Нет данных' } );
	}
	
	if ( ref $init->{'data'} ne 'ARRAY' ) {
		return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
	}
			
	my ( $h, $error ) = $m->update( $init->{'data'} );  
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
	
}

sub set {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();	
	my $res = [];
	
	unless ( $init->{'data'}  ) {
		return $c->render( json => { failue => \1, message => 'Нет данных' } );
	}
	
	if ( ref $init->{'data'} ne 'ARRAY' ) {
		return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
	}
	  
	my ( $h, $error ) = $m->set( $init->{'data'} );
	
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );  
}

sub remove {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
		
	unless ( $init->{'data'}  ) {
		return $c->render( json => { failue => \1, message => 'Нет данных' } );
	}
	
	if ( ref $init->{'data'} ne 'ARRAY' ) {
		return $c->render( json => { failue => \1, message => 'Неправильная структура json' } );
	}
	
	my ( $h, $error ) = $m->remove( $init->{'data'} );
	$c->render( json => $h ? { success => \1, data => $h } : { failue => \1, message => $error } );
  
}

sub list {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	
	$c->render( json => $m->list( $init->{'page'}, $init->{'rows'} ) );  
}


sub megamenu {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();

	$dom = Mojo::DOM->new('<div id="megamenu" class="information-blocks categories-border-wrapper"></div>');
	#$dom = Mojo::DOM->new('<div id="megamenu2" class="information-blocks categories-border-wrapper col-md-3 col-sm-6 col-xs-11">');	

	$dom->at('div#megamenu')->append_content('
		<div class="block-title size-3">Каталог товаров</div>
		<div class="accordeon_0"></div>
	');

	#$dom->at('div#megamenu2')->append_content('
	#	<div class="accordeon_0"></div>
	#');


	$c->_megamenu( { parent_id => 0 }, 0, '' );

	#open (my $fh, '>', $c->config->{'template'}->{'path'}.'/pages/default/blocks/megamenu4.html.tt');
	open (my $fh, '>', $c->config->{'template'}->{'path'}.'/pages/default/blocks/megamenu3.html.tt');	
	say $fh $dom;	
	close ($fh);
	say "OK";
	
	$c->render( text => 'OK' );
}

sub _megamenu {
	my $c = shift;
	my $filter = shift;
	my $level = shift;
	my $url_site = shift;
	my $data = $m->find( $filter );

	say "\t" x $level . $filter->{'parent_id'};
	
	if( @{ $data } ){
		for my $item ( @{ $data } ){
			my $data_child = $m->find( { parent_id => $item->{'category_id'} } );
			my $url = $url_site."/".$item->{'url'};
			
			if( scalar @{$data_child} ){				
				if( $level && $dom->at('div.accordeon_'.$filter->{'parent_id'}) ){
					$dom->at('div.accordeon_'.$filter->{'parent_id'})->append_content('<div class="accordeon-title child"><a href="'.$url.'">'.$item->{'title'}.'</a></div>');
				}
				elsif( $dom->at('div.accordeon_'.$filter->{'parent_id'}) ) {
					$dom->at('div.accordeon_'.$filter->{'parent_id'})->append_content('<div class="accordeon-title"><a href="'.$url.'">'.$item->{'title'}.'</a></div>');
				}
				elsif( $dom->at('ul.list_'.$filter->{'parent_id'}) ){
					$dom->at('ul.list_'.$filter->{'parent_id'})->append_content('
					<li class="child">
						<div class="accordeon_'.$filter->{'parent_id'}.'">
							<div class="accordeon-title"><a href="'.$url.'">'.$item->{'title'}.'</a></div>
						</div>
					</li>');
				}
				
				$dom->at('div.accordeon_'.$filter->{'parent_id'})->append_content('
					<div class="accordeon-entry cat_'.$filter->{'parent_id'}.'">
						<div class="article-container style-1">
							<ul>
								<li class="child">
									<div class="accordeon_'.$item->{'category_id'}.'">
									</div>
								</li>
							</ul>
						</div>
					</div>																				  
				') if $dom->at('div.accordeon_'.$filter->{'parent_id'});
				
				$dom->at('ul.list_'.$filter->{'parent_id'})->append_content('
					<div class="accordeon-entry cat_'.$filter->{'parent_id'}.'">
						<div class="article-container style-1">
							<ul>
								<li class="child">
									<div class="accordeon_'.$item->{'category_id'}.'">
									</div>
								</li>
							</ul>
						</div>
					</div>																				  
				') if $dom->at('ul.list_'.$filter->{'parent_id'});
				
				$dom = $c->_megamenu( { parent_id => $item->{'category_id'} }, $level+1, $url );
				

			}
			else{
				
				if( $dom->at('div.accordeon_'.$item->{'parent_id'}) && !$dom->at('ul.list_'.$item->{'parent_id'}) ){
					if( $dom->at('div.accordeon_'.$item->{'parent_id'})->child_nodes->first ){
						$dom->at('div.accordeon_'.$item->{'parent_id'})->parent->parent->content ('<ul class="list_'.$item->{'parent_id'}.'" ><li><a href="'.$url.'">'.$item->{'title'}.'</a></li></ul>');
					}
					else{
						$dom->at('div.accordeon_'.$item->{'parent_id'})->append_content('<div class="accordeon-title">'.$item->{'title'}.'</div><div class="accordeon-entry"></div>');
					}
				}
				elsif( $dom->at('ul.list_'.$item->{'parent_id'}) ){
					$dom->at('ul.list_'.$item->{'parent_id'})->append_content('<li><a href="'.$url.'">'.$item->{'title'}.'</a></li>');
				}
				
			}
		}
	}
	
	$dom;
}

my $js = [];
sub admin_megamenu {
	my $c = shift;
	return $c->reply->not_found unless $c->_init();
	my $js = $c->_admin_megamenu( { parent_id => 0 }, 0, 'Главная');
	$js = encode_json( $js );
	my $txt = "var treeData = $js";
	open (my $fh,'>',  $c->config->{'template'}->{'path'}.'/admin/content/product/megamenu.html.tt');
	say $fh $txt;
	close( $fh );
	$c->render( text => 'Ok' );
}

sub _admin_megamenu {
	my $c = shift;
	my $filter = shift;
	my $level = shift;
	my $url_site = shift;
	my $data = $m->find( $db, $filter );
	my $jsm = [];
	say "\t" x $level . $filter->{'parent_id'};
	
	if( @{ $data } ){
		for my $item ( @{ $data } ){
			my $data_child = $m->find( $db, { parent_id => $item->{'category_id'} } );
			my $url = $url_site." -> ".$item->{'title'};
			if( scalar @{$data_child} ){
				my $ret = $c->_admin_megamenu( { parent_id => $item->{'category_id'} }, $level+1, $url );
				push @{$jsm}, { title => $item->{'title'}, key => $item->{'category_id'}, isFolder => \1, unselectable => \1, children => $ret };
			}
			else{
				push @{$jsm},  { title => $item->{'title'}, key => $item->{'category_id'}, path_name => $url };
			}
		}
	}	
	$jsm;
}

1;