package Sub::Inspector;
use 5.008_001;
use strict;
use warnings;
use B ();
use Carp ();
use attributes;
use Data::Dumper;

our $VERSION = '0.01';

sub new {
    my ($class, $code) = @_;
    ref $code eq 'CODE' || do {
        local $Data::Dumper::Indent = 1;
        local $Data::Dumper::Terse  = 1;
        Carp::croak "argument isn't a subroutine reference: " . Dumper($code);
    };
    bless +{ code => $_[1] }, $_[0]
}

sub file { B::svref_2object($_[0]->{code})->GV->FILE }
sub line { B::svref_2object($_[0]->{code})->GV->LINE }
sub name { B::svref_2object($_[0]->{code})->GV->NAME }

sub proto     { B::svref_2object($_[0]->{code})->PV }
sub prototype { proto(@_) }

sub attrs      { attributes::get($_[0]->{code}) }
sub attributes { attrs(@_) }

1;
__END__

=head1 NAME

Sub::Inspector - get infomation from a subroutine reference

=head1 VERSION

This document describes Sub::Inspector version 0.01.

=head1 SYNOPSIS

    use Sub::Inspector;

    # get file, line, name

    use File::Spec;
    my $code = File::Spec->can('canonpath');
    my $inspector = Sub::Inspector->new($code);

    print $inspector->file; #=> '/Users/Cside/perl5/ ... /File/Spec/Unix.pm'
    print $inspector->line; #=> 71
    print $inspector->name; #=> 'canonpath'

    # get prototype

    use Try::Tiny;
    my $inspector2 = Sub::Inspector->new(\&try);

    print $inspector2->proto; #=> '&;@'

    # get attributes

    use AnyEvent::Handle;
    my $code = AnyEvent::Handle->can('rbuf');
    my $inspector3 = Sub::Inspector->new(\&try);

    print $inspector3->attrs; #=> ('lvalue')

=head1 DESCRIPTION

This module enable to get metadata (prototype, attributes, method name, etc) from a coderef.
We can get them by the buit-in module, B.pm. However, it is a bit difficult to memorize how to use it.

=head1 INTERFACE

=head2 Methods

=over

=item $inspector->file

=item $inspector->line

=item $inspector->name

=item $inspector->proto

alias: prototype

=item $inspector->attrs

alias: attributes

=back

=head1 SEE ALSO

=over

=item L<B>

=item L<B::Deparser>

=back

=head1 AUTHOR

Hiroki Honda (Cside) E<lt>cside.story [at] gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) Hiroki Honda.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
