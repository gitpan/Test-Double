package Test::Double::Mock;

use strict;
use warnings;
use Class::Monadic qw(monadic);
use Test::Double::Mock::Expectation;

{
    my %MOCKS = ();
    sub wrap {
        my ($class, $instance) = @_;
        $MOCKS{$instance} ||= $class->new(
            package  => ref($instance),
            instance => $instance,
        );
    }

    sub reset_all {
        %MOCKS = ();
    }

    sub verify_all {
        $_->verify for values %MOCKS;
    }
}

sub new {
    my ($class, %args) = @_;
    bless { %args, expectations => [] }, $class;
}

sub expects {
    my ($self, $method) = @_;

    my $expectation = Test::Double::Mock::Expectation->new(
        package => $self->{package},
        method  => $method,
    );

    monadic($self->{instance})->add_methods($method => $expectation->behavior);
    push @{ $self->{expectations} }, $expectation;

    return $expectation;
}

sub verify {
    my $self = shift;
    # TODO: implements
    0;
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Test::Double::Mock - Mock object

=head1 METHODS

=over 4

=item expects($name)

Returns L<Test::Double::Mock::Expectation> object.

=item verify()

Verify all expectations of this mock object.

=back

=head1 AUTHOR

NAKAGAWA Masaki E<lt>masaki@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Test::Double>, L<Test::Double::Mock::Expectation>

=cut