package t::Map::RemapGoogleMap;
use strict;
use warnings;
use base 'Test::Class';
use Test::More;
use Remap::GoogleMap;

sub startup : Test(startup => 1) {
    use_ok 'Remap::GoogleMap';
}

sub map : Test(1) {
    my $map = Remap::GoogleMap->new(url => 'http://bus.travel.rakuten.co.jp/bus/RouteMapMaviAction.do?buscode=15433&isRide=true&courseCode=311590');
    ok $map->google_map_url;
}

__PACKAGE__->runtests;

