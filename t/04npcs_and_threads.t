#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Games::Mythic;

my $game = Games::Mythic->new();

srand(3);

ok( $game->add_npc('Balin') );
is( $game->random_npc(), 'Balin' );

ok( $game->add_thread('Write Book of Mazarbul') );
is( $game->random_thread(), 'Write Book of Mazarbul' );

ok( $game->add_thread('Re-colonize Moria') );
is( $game->random_thread(), 'Re-colonize Moria' );

ok( $game->remove_thread('Re-colonize Moria') );
is( $game->random_thread(), 'Write Book of Mazarbul' );

done_testing();
