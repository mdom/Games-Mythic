#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Games::Mythic;

my $game = Games::Mythic->new();

srand(1);

is( $game->random_event(), 'Remote event - Develop/Status quo' );
is( $game->random_event(), 'Introduce a new NPC - Create/Goals' );

done_testing();
