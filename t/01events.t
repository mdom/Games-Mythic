#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Games::Mythic;

my $game = Games::Mythic->new();

srand(1);

is( $game->random_event(), 'Recruit/Food');
is( $game->random_event(), 'Care/Expectations');

done_testing();
