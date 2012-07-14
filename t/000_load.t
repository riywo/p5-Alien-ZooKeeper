#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Alien::ZooKeeper';
}

diag "Testing Alien::ZooKeeper/$Alien::ZooKeeper::VERSION";
