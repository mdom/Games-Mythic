#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Games::Mythic;

my $game = Games::Mythic->new();

srand(1);

is( $game->rank_to_index('high'), 7 );
is( $game->get_odds( 'high', 'exceptional' ), 35 );
is( $game->get_odds( 'above-average', 'high' ), 45 );
is( $game->get_odds( 'superhuman4', 'superhuman3' ), 70 );

done_testing();
