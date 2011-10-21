package Remap::GoogleMap;
use strict;
use warnings;
use CGI::Carp qw(croak);
use LWP::UserAgent;
use URI;

sub new {
    my ($class, %args) = @_;
    my $self = bless {
        url => URI->new($args{url}),
    }, $class;
    return $self;
}

sub latlng {
    my $self = shift;
    my $ua = LWP::UserAgent->new;
    my $res = $ua->get($self->{url});
    if ($res->is_success) {
        my $content = $res->decoded_content;
        if ($content =~ /rakutenMap/) {
            return $self->rakuten_map_latlng($content);
        } elsif ($content =~ /YMap/) {
            return $self->yahoo_map_latlng($content);
        } elsif ($content =~ /LDMap/) {
            return $self->livedoor_map_latlng($content);
        } elsif ($content =~ /OpenLayers/) {
            return $self->openstreet_map_latlng($content);
        } elsif ($content =~ /maps.google.com/) {
            return $self->google_map_latlng($content);
        }
    }
    return undef;
}

sub rakuten_map_latlng {
    my ($self, $content) = @_;
    my ($lat) = $content =~ /initlat.+?'(\d+?)'/;
    my ($lng) = $content =~ /initlng.+?'(\d+?)'/;
    return undef unless ($lat && $lng);
    return $self->j2gpoint($lat / 3600000, $lng / 3600000);
}

# japanese geometory convert global;
sub j2gpoint {
    my ($self, $lat, $lng) = @_;
    my $glat = $lat - $lat * 0.00010695 + $lng * 0.000017464 + 0.0046017;
    my $glng = $lng - $lat * 0.000046038 - $lng * 0.000083043 + 0.010040;
    return {lat => $glat, lng => $glng};
}

sub yahoo_map_latlng {
    my ($self, $content) = @_;
    my ($lat) = $content =~ /lat:'(\d+?.\d+?)'/;
    my ($lng) = $content =~ /lon:'(\d+?.\d+?)'/;
    return undef unless ($lat && $lng);
    return {lat => $lat, lng => $lng};
}

sub livedoor_map_latlng {
    my ($self, $content) = @_;
    my ($lat) = $content =~ /lat=(\d+?.\d+?)&/;
    my ($lng) = $content =~ /lng=(\d+?.\d+?)&/;
    return undef unless ($lat && $lng);
    return $self->j2gpoint($lat, $lng);
}

sub openstreet_map_latlng {
    my ($self, $content) = @_;
    my ($lat) = $content =~ /latitude.+?(\d+?.\d+?);/;
    my ($lng) = $content =~ /longitude.+?(\d+?.\d+?);/;
    return undef unless ($lat && $lng);
    return {lat => $lat, lng => $lng};
}

sub google_map_latlng {
    my ($self, $content) = @_;
    my ($lat, $lng) = $content =~ /center=(\d+?.\d+?),(\d+?.\d+?)&/;
    return undef unless ($lat && $lng);
    return {lat => $lat, lng => $lng};
}

sub google_map_url {
    my ($self) = shift;
    my $latlng = $self->latlng or croak 'failed latlng';
    my $url = URI->new("http://maps.google.co.jp/maps");
    $url->query_form(
        q => $latlng->{lat} . "," . $latlng->{lng}
    );
    return $url->as_string;
}

1;
