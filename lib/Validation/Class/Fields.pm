# ABSTRACT: Container Class for Validation::Class::Field Objects

package Validation::Class::Fields;

use Validation::Class::Core 'build_args';

# VERSION

use base 'Validation::Class::Mapping';

use Validation::Class::Field;

=head1 DESCRIPTION

Validation::Class::Fields is a container class for L<Validation::Class::Field>
objects and is derived from the L<Validation::Class::Mapping> class.

=cut

sub add {

    my $self = shift;

    my $arguments = $self->build_args(@_);

    while (my ($key, $value) = each %{$arguments}) {

        # do not overwrite
        unless (defined $self->{$key}) {
            $self->{$key} = $value; # accept an object as a value
            $self->{$key} = Validation::Class::Field->new($value)
                unless "Validation::Class::Field" eq ref $self->{$key}
            ;
        }

    }

    return $self;

}

#sub clear {
#    #noop - fields can't be deleted this way
#}

1;
