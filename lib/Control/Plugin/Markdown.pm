package Control::Plugin::Markdown;
use Text::Markdown 'markdown';
use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self,$app) = @_;
		
	$app->helper(
		markdown => sub {
			my $c    = shift;
			my $text = shift || '';
			return markdown($text);
		}
	);
		
	return 1;
}

1;