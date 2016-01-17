use strict;
use warnings;

use Test::More;
use Test::PerlTidy;

# i couldn't use run_tests as it does not check scripts

my @files = glob('t/*.t xt/*.t bin/* lib/Games/*.pm');

for my $file (@files) {
    local $Test::PerlTidy::MUTE = 1;
    ok( Test::PerlTidy::is_file_tidy($file), $file );
}

done_testing;
