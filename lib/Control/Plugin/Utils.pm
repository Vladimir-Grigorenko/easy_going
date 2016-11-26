package Control::Plugin::Utils;
use CSS::Minifier::XS qw(minify);
use Data::Dumper;

use Mojo::Base 'Mojolicious::Plugin';
sub register {
	my ($self,$app) = @_;

	
	$app->helper( mini_css => sub {
		my ($c, $css) = @_;
		$css = $c->app->config->{'css'}->{'path'} . $css;
		return '' unless $css;
		return minify($css);
	});
}

1;