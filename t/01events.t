#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::MockRandom 'Games::Mythic';
use Games::Mythic;

my $game = Games::Mythic->new();

srand( 0.06, 0.45, 0.83, 0.30, 0.56, 0 );

is( $game->random_event(), 'Remote event - Develop/Status quo' );
is( $game->random_event(), 'Introduce a new NPC - Create/Goals' );

done_testing();
