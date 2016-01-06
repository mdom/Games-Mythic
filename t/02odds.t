#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Games::Mythic;

my $game = Games::Mythic->new();

srand(1);

is( $game->rank_to_index('high'), 7 );
is_deeply( $game->get_odds( 'high',          'exceptional' ), [ 7,  35, 88 ] );
is_deeply( $game->get_odds( 'above-average', 'high' ),        [ 9,  45, 90 ] );
is_deeply( $game->get_odds( 'superhuman4',   'superhuman3' ), [ 14, 70, 95 ] );

is( $game->ask( 'high', 'exceptional', 88 ), 'exceptional-yes' );
is( $game->ask( 'high', 'exceptional', 35 ), 'yes' );
is( $game->ask( 'high', 'exceptional', 34 ), 'no' );
is( $game->ask( 'high', 'exceptional', 8 ),  'no' );
is( $game->ask( 'high', 'exceptional', 7 ),  'exceptional-no' );

ok( $game->ask( 'high', 'exceptional' ) );

done_testing();
