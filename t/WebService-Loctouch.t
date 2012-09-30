package t::WebService::Loctouch;
use strict;
use warnings;
use base 'Test::Class';
use Test::More;
use WebService::Loctouch;
use Data::Dumper;

sub startup : Test(startup => 1) {
    use_ok 'WebService::Loctouch';
}

sub spots_search : Test(2) {
    ok my $loc = WebService::Loctouch->new;
    my @spots =  $loc->spots_search(
        'category_id' => '140',
        'lat' => '34.341927',
        'lng' => '134.054765',
    );
    ok $spots[0]{name};
}

__PACKAGE__->runtests;

