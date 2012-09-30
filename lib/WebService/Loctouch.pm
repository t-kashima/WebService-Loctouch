package WebService::Loctouch;
use strict;
use warnings;
use LWP::UserAgent;
use URI;
use JSON;
use Data::Dumper;

sub new {
    my ($class, %args) = @_;
    my $self = bless {
        baseurl => 'https://api.loctouch.com/v1/',
        ua => LWP::UserAgent->new,
    }, $class;
    return $self;
}

sub spots_search {
    my ($self, %args) = @_;
    my $url = URI->new($self->{baseurl}.'spots/search');
    $url->query_form(%args);
    my $r = $self->{ua}->get($url->as_string);
    my $content = decode_json($r->content);
    return $content unless ($r->is_success && $content->{code} == 200);
    return @{ $content->{spots} };
}

1;
