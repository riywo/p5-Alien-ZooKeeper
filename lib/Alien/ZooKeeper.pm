package Alien::ZooKeeper;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use File::ShareDir qw(dist_dir);;
use File::Spec;

use constant prefix => dist_dir('Alien-ZooKeeper');

sub include {
    return File::Spec->catfile(prefix, 'include');
}

sub lib {
    return File::Spec->catfile(prefix, 'lib');
}

sub bin {
    return File::Spec->catfile(prefix, 'bin');
}

1;
__END__

=head1 NAME

Alien::ZooKeeper - Installation of Perl bindings to ZooKeeper

=head1 VERSION

This document describes Alien::ZooKeeper version 0.01.

=head1 SYNOPSIS

    use Net::ZooKeeper; # see Net::ZooKeeper documentation

=head1 DESCRIPTION

This distribution installs F<Net/ZooKeeper.pm> for you.

NOTES: This distribution doesn't install zookeeper itself yet, as
other Alien::* dists do, but it does so in a future.

=head1 INSTALL

First, you must install the following C libraries which ZooKeeper depends on:

    pkg-config
    gettext
    glib
    xml2
    pango
    cairo

Some of them might be installed by default.

Second, you can install this distribution by C<cpanm>:

    cpanm Alien::ZooKeeper

Then, you can use the C<Net::ZooKeeper> module.

=head1 DEPENDENCIES

Perl 5.8.1 or later.

ZooKeeper depends on pkg-config, gettext, glib, xml2, pango and  cairo.
You shuould install those libraries by yourself with a package manager.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<http://zookeeper.apache.org/>

L<RRDs>

=head1 AUTHOR

Ryosuke IWANAGA (riywo) E<lt>riywo.jp(at)gmail.comE<gt>;

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, Ryosuke IWANAGA (riywo). All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
