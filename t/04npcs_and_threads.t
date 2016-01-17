#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::MockRandom 'Games::Mythic';
use Games::Mythic;

my $game = Games::Mythic->new();

ok( $game->add_npc('Balin') );
is( $game->random_npc(), 'Balin' );

ok( $game->add_thread('Write Book of Mazarbul') );
is( $game->random_thread(), 'Write Book of Mazarbul' );

ok( $game->add_thread('Re-colonize Moria') );
is( $game->random_thread(), 'Re-colonize Moria' );

srand(0.5);

is( $game->random_thread(), 'Write Book of Mazarbul' );

ok( $game->remove_thread('Re-colonize Moria') );
is( $game->random_thread(), 'Write Book of Mazarbul' );

done_testing();
