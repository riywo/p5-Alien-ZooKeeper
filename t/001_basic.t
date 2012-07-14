#!perl -w
use strict;
use Test::More;

use Alien::ZooKeeper;

note( Alien::ZooKeeper->prefix );

ok -d Alien::ZooKeeper->prefix;

ok -d Alien::ZooKeeper->include;
ok -d Alien::ZooKeeper->lib;
ok -d Alien::ZooKeeper->bin;

done_testing;
