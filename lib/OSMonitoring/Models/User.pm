package OSMonitoring::Models::User;

use parent qw(OSMonitoring::Models::BaseRequestModel);

my $USER_MODEL_VALIDATION_REGEXES = {
    username => '^[a-z_]([a-z0-9_-]{0,31}|[a-z0-9_-]{0,30}\$)$',
    password => '^.{8,}$'
};

sub validate {
    my ($self) = @_;
    return $self->SUPER::validate($USER_MODEL_VALIDATION_REGEXES);
}

sub getUsername {
    my ($self) = @_;
    return $self->getData()->{username};
}

sub getPassword {
    my ($self) = @_;
    return $self->getData()->{password};
}

1;