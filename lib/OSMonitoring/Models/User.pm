package OSMonitoring::Models::User;

sub new {
    my ($class, $username, $password) = @_;
    my $user = {
        username => $username,
        password => $password
    };

    my $self = {
        user => $user
    };

    bless $self, $class;
}

sub getUser {
    my ($self) = @_;
    return $self->{user};
}

sub getUsername {
    my ($self) = @_;
    return $self->getUser()->{username};
}

sub getPassword {
    my ($self) = @_;
    return $self->getUser()->{password};
}

1;