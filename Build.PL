#!perl
use strict;
use warnings;

use inc::MyBuilder;
use Module::Build::Compat;
use File::Path qw(rmtree);
use IO::Handle;

use LWP::Simple;

STDOUT->autoflush(1);

my $name      = 'zookeeper';
my $zookeeper = "http://ftp.tsukuba.wide.ad.jp/software/apache/zookeeper/zookeeper-3.4.3/zookeeper-3.4.3.tar.gz";

print "# donwloading $zookeeper\n";
print "# => ", scalar mirror($zookeeper, "$name.tar.gz"), "\n";
print "# unpacking $name.tar.gz\n";
system("tar", "xzf",  "$name.tar.gz");
rmtree($name);
my $version = do {
    my @dirs = <zookeeper-*>;
    @dirs == 1 or die "XXX: too many zookeeper-*/: @dirs";
    ( $dirs[0] =~ m/ (\d+ (?: \. \d+)+ ) /xms )[0];
};
print "# zookeeper version $version\n";
rename "$name-$version" => $name;

print "# witing Makefile\n";
my $builder = inc::MyBuilder->new(
    module_name => 'Alien::ZooKeeper',
    dist_author => 'Ryosuke IWANAGA (riywo) <riywo.jp(at)gmail.com>',
    license     => 'perl',

    requires    => {
        perl => 5.008_001,

        'File::ShareDir' => 0,
    },

    configure_requires => {
        'File::chdir'   => 0,
        'File::Which'   => 0,
        'LWP::Simple'   => 0,
        'Module::Build' => 0,
    },
    build_requires => {
        'File::ShareDir' => 0,
    },
    test_requires => {
        'Test::More'     => 0.88,
        'Test::Requires' => 0.06,
    },

    share_dir => 'alien',

    needs_compiler => 1,

    dist_meta => 1, # to make `cpanm .` happy

    no_index => {
        directory =>  [
            'inc',
            'author',
        ],
    },

    add_to_cleanup => [
        $name,
        'Makefile',
        'alien',
        'blib',
    ],
);

$builder->notes( zookeeper  => $zookeeper );
$builder->notes( name       => $name    );
$builder->notes( version    => $version );
$builder->notes( installdir => 'alien' );

$builder->create_build_script();

# write Makefile for an easy interface to the build script
Module::Build::Compat->write_makefile(build_class => ref $builder);

