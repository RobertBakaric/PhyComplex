#!perl -T
use 5.014;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Complexity::Physical' ) || print "Bail out!\n";

}

diag( "\nTesting Complexity::Physical v$Complexity::Physical::VERSION, Perl $], $^X" );

