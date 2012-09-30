package WebService::Loctouch;
use strict;
use warnings;
use LWP::UserAgent;
use Carp qw/croak/;
use URI;
use JSON;

sub new {
    my ($class, %args) = @_;
    my $self = bless {
        baseurl => 'https://api.loctouch.com/v1',
        ua => LWP::UserAgent->new,
    }, $class;
    return $self;
}

sub spots_search {
    my ($self, %args) = @_;
    my $url = URI->new($self->{baseurl} . '/spots/search');
    $url->query_form(%args);
    my $r = $self->{ua}->get($url->as_string);
    my $content = decode_json($r->content);
    return $content unless ($r->is_success && $content->{code} == 200);
    return $content->{spots};
}

sub spots {
    my ($self, %args) = @_;
    croak 'Error: spots method required spot id args' unless $args{id};
    my $url = URI->new($self->{baseurl} . '/spots/' . $args{id});
    my $r = $self->{ua}->get($url->as_string);
    my $content = decode_json($r->content);
    return $content unless ($r->is_success && $content->{code} == 200);
    return $content->{spot};
}

sub spots_photos {
   my ($self, %args) = @_;
    croak 'Error: spots method required spot id args' unless $args{id};
    my $url = URI->new($self->{baseurl} . '/spots/' . $args{id} . '/photos');
    my $r = $self->{ua}->get($url->as_string);
    my $content = decode_json($r->content);
    return $content unless ($r->is_success && $content->{code} == 200);
    return $content->{photos};
}

1;
