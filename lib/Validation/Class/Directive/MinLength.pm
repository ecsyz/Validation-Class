# ABSTRACT: MinLength Directive for Validation Class Field Definitions

package Validation::Class::Directive::MinLength;

use strict;
use warnings;

use base 'Validation::Class::Directive';

use Validation::Class::Util;

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Simple;

    my $rules = Validation::Class::Simple->new(
        fields => {
            password => {
                min_length => 5
            }
        }
    );

    # set parameters to be validated
    $rules->params->add($parameters);

    # validate
    unless ($rules->validate) {
        # handle the failures
    }

=head1 DESCRIPTION

Validation::Class::Directive::MinLength is a core validation class field
directive that validates the length of all characters in the associated
parameters.

=cut

has 'mixin'     => 1;
has 'field'     => 1;
has 'multi'     => 0;
has 'message'   => '%s must not contain less than %s characters';

sub validate {

    my $self = shift;

    my ($proto, $field, $param) = @_;

    if (defined $field->{min_length} && defined $param) {

        my $min_length = $field->{min_length};

        if ( $field->{required} || $param ) {

            if (length($param) < $min_length) {

                $self->error(@_, $min_length);

            }

        }

    }

    return $self;

}

1;
