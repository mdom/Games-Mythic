#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Games::Mythic;

my $game = Games::Mythic->new();

is( $game->chaos_level, 5 );
$game->chaos_level(10);
is( $game->chaos_level, 9 );
$game->chaos_level(-10);
is( $game->chaos_level,    1 );
is( $game->increase_chaos, 2 );
is( $game->decrease_chaos, 1 );

done_testing();
