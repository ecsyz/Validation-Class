# ABSTRACT: Generic Container Class for Hash References

package Validation::Class::Mapping;

use Validation::Class::Core '!has', '!hold';
use Hash::Merge ();

# VERSION

=head1 SYNOPSIS

    use Validation::Class::Mapping;

    my $foos = Validation::Class::Mapping->new;

    $foos->add(foo => 'one foo');
    $foos->add(bar => 'one bar');

    print $foos->count; # 2 objects

=head1 DESCRIPTION

Validation::Class::Mapping is a container class that provides general-purpose
functionality for hashref objects.

=cut

=method new

    my $self = Validation::Class::Mapping->new;

=cut

sub new {

    my $class = shift;

    my $arguments = $class->build_args(@_);

    my $self = bless {}, $class;

    $self->add($arguments);

    return $self;

}

=method add

    $self = $self->add(foo => 1, bar => 2);

=cut

sub add {

    my $self = shift;

    my $arguments = $self->build_args(@_);

    while (my ($key, $value) = each %{$arguments}) {

        $self->{$key} = $value;

    }

    return $self;

}

=method clear

    $self = $self->clear;

=cut

sub clear {

    my ($self) = @_;

    $self->delete($_) for keys %{$self};

    return $self;

}

=method count

    my $count = $self->count;

=cut

sub count {

    return scalar(shift->keys);

}

=method delete

    $value = $self->delete($name);

=cut

sub delete {

    my ($self, $name) = @_;

    return delete $self->{$name};

}

=method each

    $self = $self->each(sub{

        my ($key, $value) = @_;

    });

=cut

sub each {

    my ($self, $code) = @_;

    $code ||= sub {};

    while (my @args = each(%{$self})) {

        $code->(@args);

    }

    return $self;

}

=method get

    my $value = $self->get($name); # i.e. $self->{$name}

=cut

sub get {

    my ($self, $name) = @_;

    return $self->{$name};

}

=method grep

    my @keys = $self->grep(qr/update_/);

=cut

sub grep {

    my ($self, $pattern) = @_;

    $pattern = qr/$pattern/ unless "REGEXP" eq uc ref $pattern;

    return (grep { $_ =~ $pattern } keys %{$self});

}

=method has

    if ($self->has($name)) {

    }

=cut

sub has {

    my ($self, $name) = @_;

    return defined $self->{$name} ? 1 : 0;

}

=method hash

    my $hash = $self->hash;

=cut

sub hash {

    return {shift->list};

}

=method iterator

    my $next = $self->iterator();
    # i.e. $self->iterator('sort', sub{ (shift) cmp (shift) })

    while (my $value = $next->()) {

    }

=cut

sub iterator {

    my ($self, $function, @arguments) = @_;

    $function ||= 'keys';

    my @keys = ($self->$function(@arguments));

    my $i = 0;

    return sub {

        return undef unless defined $keys[$i];

        return $self->get($keys[$i++]);

    }

}

=method keys

    my @keys = $self->keys;

=cut

sub keys {

    return (keys(shift->hash));

}

=method list

    my %hash = $self->list;

=cut

sub list {

    return (%{$_[0]});

}

=method merge

    $self->merge($hashref);

=cut

sub merge {

    my $self = shift;

    my $arguments = $self->build_args(@_);

    $self->add(Hash::Merge::merge($self->hash, $arguments));

    return $self;

}

=method nsort

    my @keys = $self->nsort;

=cut

sub nsort {

    my ($self) = @_;

    my $code = sub { $_[0] <=> $_[1] };

    return $self->sort($code);

}

=method pairs

    my @pairs = $self->pairs;
    # or filter using $self->pairs('grep', $regexp);

    foreach my $pair (@pairs) {
        # $pair->{key} is $pair->{value};
    }

=cut

sub pairs {

    my ($self, $function, @arguments) = @_;

    $function ||= 'keys';

    my @keys = ($self->$function(@arguments));

    my @pairs = map {{ key => $_, value => $self->get($_) }} (@keys);

    return (@pairs);

}

=method rmerge

    $self->rmerge($hashref);

=cut

sub rmerge {

    my $self = shift;

    my $arguments = $self->build_args(@_);

    $self->add(merge($arguments, $self->hash));

    return $self;

}

=method rnsort

    my @keys = $self->rnsort;

=cut

sub rnsort {

    my ($self) = @_;

    my $code = sub { $_[1] <=> $_[0] };

    return $self->sort($code);

}

=method rsort

    my @keys = $self->rsort;

=cut

sub rsort {

    my ($self) = @_;

    my $code = sub { $_[1] cmp $_[0] };

    return $self->sort($code);

}

=method sort

    my @keys = $self->sort(sub{...});

=cut

sub sort {

    my ($self, $code) = @_;

    return "CODE" eq ref $code ?
        sort { $a->$code($b) } ($self->keys) : sort { $a cmp $b } ($self->keys);

}

=method values

    my @values = $self->values;

=cut

sub values {

    return (values(shift->hash));

}

1;