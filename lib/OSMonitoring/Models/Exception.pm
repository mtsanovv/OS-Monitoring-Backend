package OSMonitoring::Models::Exception;

sub new {
    my ($class, $status, $message) = @_;
    my $exception = {
        status => $status,
        title => Dancer2::Core::HTTP->status_message($status),
        exception => $message
    };

    my $self = {
        exception => $exception
    };

    bless $self, $class;
}

sub getException {
    my ($self) = @_;
    return $self->{exception};
}

1;