package MooseX::ExpiredAttribute;

use Moose 2.1204 ();

use MooseX::ExpiredAttribute::Role::Meta::Attribute;
use MooseX::ExpiredAttribute::Role::Object;

$MooseX::ExpiredAttribute::VERSION = 0.023;

1;

__END__

=pod

=head1 NAME

MooseX::ExpiredAttribute - Expired and auto rebuilded attributes in Moose objects

=head1 SYNOPSIS

    package MyClass;

    use Moose;
    use MooseX::ExpiredAttribute;

    has 'config' => (
        traits  => [ qw( Expired ) ],
        is      => 'rw',
        isa     => 'HashRef',
        expires => 5.5,
        lazy    => 1,
        builder => '_build_config',
    );

    sub _build_config {
        ... # open config file, read and hash forming
    }

    package main;

    my $prog = MyClass->new;

    $prog->config;      # The first calling - here read file and make hash of configs
    sleep 2;            # only 2 seconds elapsed...
    $prog->config;      # ... there is no calling of builder again - only attribute value returning
    sleep 4;            # elapsed ~ 6 seconds from first calling of builder - more than 5.5 seconds elapsed (the 'expires' option)
    $prog->config;      # ... there is new calling of builder - rereading config file again
    sleep 3;            # only 3 seconds elapsed from rebuilding...
    $prog->config;      # ... only old value is returned
    ...

and even by this way:

    package MyRole;

    use Moose::Role;
    use MooseX::ExpiredAttribute;

    has 'config' => (
        traits   => [ qw( Expired ) ],
        is       => 'rw',
        isa      => 'HashRef',
        expires  => 5.5,
        lazy     => 1,
        builder  => '_build_config',
    );

    sub _build_config {
        ... # open config file, read and hash forming
    }

    package MyClass;

    with 'MyRole';

    has 'foo' => ( is => 'rw' );

    package main;

    my $prog = MyClass->new;

    $prog->config;      # First calling - here read file and hash of configs
    ...

=head1 DESCRIPTION

This module allows to create expired attributes with auto-rebuilding feature
after elapsed time. The goal of module is attrubutes which can be able to have
the time-varying value. For example some configs can be changed by user during
program runtime and wished to be reread by program every one minute for example.
All that is required from you to add the trait to an attribute and to add the
'expires' option (may be fractal seconds). An attribute should have a builder
too!

=head1 SEE ALSO

=over

=item L<MooseX::ExpiredAttribute::Role::Object>

=item L<MooseX::ExpiredAttribute::Role::Meta::Attribute>

=back

=head1 AUTHOR

This module has been written by Perlover <perlover@perlover.com>

=head1 LICENSE

This module is free software and is published under the same terms as Perl
itself.

=cut
