package t::WebService::Loctouch;
use strict;
use warnings;
use base 'Test::Class';
use Test::More;
use WebService::Loctouch;

sub startup : Test(startup => 2) {
    use_ok 'WebService::Loctouch';
    ok my $loc = WebService::Loctouch->new;
}

sub spots_search : Test(2) {
    my $loc = WebService::Loctouch->new;
    my @spots;

    @spots =  @{ $loc->spots_search(
        'category_id' => '140',
        'lat' => '34.341927',
        'lng' => '134.054765',
    ) };

    ok $spots[0]{name};

    @spots =  @{ $loc->spots_search(
        'query' => 'cafe',
        'limit' => 10,
    ) };

    ok $spots[0]{name};
}

sub spot : Test(3) {
    my @spots;
    my $loc = WebService::Loctouch->new;

    my %spot =  %{ $loc->spots('id' => 140) };
    ok $spot{name};
    my @photo =  @{ $loc->spots_photos('id' => 140) };
    is $spot{name}, $photo[0]{touch}{spot}{name};
    ok $photo[0]{touch}{photo}{small};
}

__PACKAGE__->runtests;

