package OSMonitoring::Models::UserDeletion;

use parent qw(OSMonitoring::Models::BaseRequestModel);

my $USER_DELETION_MODEL_VALIDATION_REGEXES = {
    deleteHome => '^0|1$'
};

sub validate {
    my ($self) = @_;
    return $self->SUPER::validate($USER_DELETION_MODEL_VALIDATION_REGEXES);
}

sub shouldDeleteHome {
    my ($self) = @_;
    return $self->getData()->{deleteHome};
}

1;