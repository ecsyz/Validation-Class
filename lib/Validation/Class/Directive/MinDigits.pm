# ABSTRACT: MinDigits Directive for Validation Class Field Definitions

package Validation::Class::Directive::MinDigits;

use strict;
use warnings;

use base 'Validation::Class::Directive';

use Validation::Class::Core;

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Directive::MinDigits;

    my $directive = Validation::Class::Directive::MinDigits->new;

=head1 DESCRIPTION

Validation::Class::Directive::MinDigits is a core validation class field directive
that provides the ability to do some really cool stuff only we haven't
documented it just yet.

=cut

has 'mixin'     => 1;
has 'field'     => 1;
has 'multi'     => 0;
has 'message'   => '%s must contain %s or more digits';

sub validate {

    my $self = shift;

    my ($proto, $field, $param) = @_;

    if (defined $field->{min_digits} && defined $param) {

        my $min_digits = $field->{min_digits};

        if ( $field->{required} || $param ) {

            my @i = ($param =~ /[0-9]/g);

            if (@i < $min_digits) {

                $self->error(@_, $min_digits);

            }

        }

    }

    return $self;

}

1;
