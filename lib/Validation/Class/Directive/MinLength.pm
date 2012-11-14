# ABSTRACT: MinLength Directive for Validation Class Field Definitions

package Validation::Class::Directive::MinLength;

use base 'Validation::Class::Directive';

use Validation::Class::Core;

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Directive::MinLength;

    my $directive = Validation::Class::Directive::MinLength->new;

=head1 DESCRIPTION

Validation::Class::Directive::MinLength is a core validation class field directive
that provides the ability to do some really cool stuff only we haven't
documented it just yet.

=cut

has 'mixin'     => 1;
has 'field'     => 1;
has 'multi'     => 0;
has 'validator' => \&_build_validator;

sub _build_validator {

    my ( $directive, $value, $field, $class ) = @_;

    if (defined $value) {

        unless ( length($value) >= $directive ) {

            my $handle = $field->{label} || $field->{name};
            my $characters = int( $directive ) > 1 ?
                "characters" : "character";

            my $error = "$handle must contain at-least "
                ."$directive $characters";

            $field->errors->add($field->{error} || $error);

            return 0;

        }

    }

    return 1;

}

1;