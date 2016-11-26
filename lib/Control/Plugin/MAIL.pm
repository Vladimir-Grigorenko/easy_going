package Control::Plugin::MAIL;
use Mail::RFC822::Address  qw(valid validlist);
#use Net::SMTP::SSL;
use Mail::Sender;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
	my ($self,$app) = @_;
	
	$app->helper( mailrfc => sub {
		my ($c, $mail) = @_;
		return valid( $mail ) ? 1 : 0;
	});
	
	$app->helper(
		mail => sub {
			my $c    = shift;
			my $data = shift || '';
			return undef unless %{$data};
			
			$data->{'subject'} = $data->{'subject'} || $app->config->{'mail'}->{'subject'};
			$data->{'mess'}    = $data->{'mess'} || $app->config->{'mail'}->{'mess'};
			
			$Mail::Sender::ver = '';
			$Mail::Sender::NO_X_MAILER = 1;
			
			my $sender = new Mail::Sender ({
				smtp => $app->config->{'mail'}->{'host'},
				from => $app->config->{'mail'}->{'from'},
				replyto => $app->config->{'mail'}->{'from'},
				skip_bad_recipients  => 0,
				headers => {
					'X-Mailer' => 'shtogarenko.pp.ua',
					'Errors-To' => $app->config->{'mail'}->{'from'}
				},
				priority => 1
			});

			eval {
				$sender->OpenMultipart({
					to      => $data->{'to'},
					subject => $data->{'subject'},
					encoding => 'base64',
					ctype => 'text/html; charset=UTF-8',
				});
			
				$sender->Body;
				$sender->SendLineEnc( $data->{'mess'} );	
				$sender->Close();
			};
			
			say $data->{'mess'};
		
			if( $sender->{'error'} ) {
				say "$sender->{'error'}\t$sender->{'error_msg'}";
			}
			1;
		}
	);
		
	return 1;
}

1;

__END__

	$app->helper(
		mail => sub {
			my $c    = shift;
			my $data = shift || '';
			return undef unless %{$data};
			
			$data->{'subject'} = $data->{'subject'} || $app->config->{'mail'}->{'subject'};
			$data->{'mess'}    = $data->{'mess'} || $app->config->{'mail'}->{'mess'};
			
			my $smtp = Net::SMTP::SSL->new( $app->config->{'mail'}->{'host'},
				#Port    => $app->config->{'mail'}->{'port'},
				Timeout => $app->config->{'mail'}->{'timeout'},
				Debug   => $app->config->{'mail'}->{'debug'}
			);
			
			$smtp->auth( $app->config->{'mail'}->{'login'} , $app->config->{'mail'}->{'pass'} ) if $app->config->{'mail'}->{'login'};
			$smtp->mail( $app->config->{'mail'}->{'from'} );
			
			if ( $smtp->to( $data->{'to'} ) ){
				$smtp->data();
				$smtp->datasend("To: ".$data->{'to'}."\n");
				$smtp->datasend("From: ".$app->config->{'mail'}->{'from'}." \n");
				$smtp->datasend("Subject: ".$data->{subject}." \n");
				$smtp->datasend("\n");
				$smtp->datasend( $data->{'mess'} || '' );
				$smtp->dataend();
			}
			else{
				$smtp->message();
				return undef, $smtp->message();
			}
			$smtp->quit;
			1;
		}
	);