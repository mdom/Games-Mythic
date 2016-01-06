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

done_testing();
