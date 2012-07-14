package inc::MyBuilder;
use strict;
use warnings FATAL => 'all';
use parent qw(Module::Build);

use Fatal qw(open);
use Carp;
use Config;
use Cwd;
use File::Path;

use File::chdir;
use File::Which;

sub xsystem {
    my(@args) = @_;
    print "->> ", join(' ', @args), "\n";
    system(@args) == 0 or croak "Failed to system(@args): $!";
}

sub ACTION_manpages {
    # doesn't create man pages
}

sub ACTION_code { # default action
    my($self, @args) = @_;

    my $prefix    = $CWD . '/' . $self->notes('installdir');
    mkpath($prefix);

#    my $bindir = $self->install_destination('bin');
    {
        local $CWD = $self->notes('name') . '/src/c';

        local $ENV{PERL} = $self->perl;
        local $ENV{CC}   = $self->maybe_ccache();
        xsystem(
            './configure',

            "--prefix=$prefix",
#            "--bindir=$bindir",

        ) unless -f 'Makefile';

        xsystem($Config{make});
        xsystem($Config{make}, 'install');
    }

=pod
    my @libdirs = (
        '/usr/local/lib',
        map { ("$_/usr/lib", "$_/usr/X11/lib") } </Developer/SDKs/MacOSX*>,
    );

    my $libs = do {
        open my $fh, '<', $self->notes('name') . '/Makefile';

        my $libs = '';
        while(<$fh>) {
            if(/ALL_LIBS \s+ = \s+ (.+) /xms) {
                chomp($libs = $1);
            }
        }
        join ' ', (map { "-L$_" } @libdirs),  $libs;
    };

    my $rpath = Cwd::abs_path($self->notes('name') . '/src/.libs') or die;
=cut

    $self->perl_bindings(sub {
        xsystem($self->perl,
            'Makefile.PL',
            '--zookeeper-include', "$prefix/include",
            '--zookeeper-lib'    , "$prefix/lib");
        xsystem($Config{make});
    });

    $self->SUPER::ACTION_code(@args);
}

sub ACTION_test {
    my($self, @args) = @_;

    $self->ACTION_code();

    $self->perl_bindings(sub {
        xsystem($Config{make}, 'test');
    });

    $self->SUPER::ACTION_test(@args);
}


sub ACTION_install {
    my($self, @args) = @_;

    $self->perl_bindings(sub {
        xsystem($Config{make}, 'install');
    });

    $self->SUPER::ACTION_install(@args);
}

sub perl_bindings {
    my($self, $block) = @_;
    my $path = $self->binding_dir('zkperl');
    {
        local $CWD = $path;
        print "In $path:\n";

        $block->();
    }
    return;
}


sub binding_dir {
    my($self, $name) = @_;

    return $self->notes('name') . '/src/contrib/' . $name;
}

sub maybe_ccache {
    my $cc = $Config{cc};

    return $cc if $cc =~ /ccache/;

    my $ccache = which('ccache');
    return $ccache ? "ccache $cc" : $cc;
}

1;
