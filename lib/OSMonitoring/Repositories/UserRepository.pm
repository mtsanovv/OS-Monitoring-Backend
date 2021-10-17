package OSMonitoring::Repositories::UserRepository;

use Dancer2 appname => 'OSMonitoring';

use OSMonitoring::Persistence::Persister;

sub new {
    my ($class) = @_;
    my $self = {
        persister => OSMonitoring::Persistence::Persister->new()
    };

    bless $self, $class;
}

sub getPersister {
    my ($self) = @_;
    return $self->{persister};
}

sub getAllUsers {
    my ($self) = @_;
    my $persister = $self->getPersister();
    return $persister->getAllUsers();
}

sub createUser {
    my ($self, $userModel) = @_;
    my $persister = $self->getPersister();
    my ($username, $password) = ($userModel->getUsername(), $userModel->getPassword());

    if(defined scalar getpwnam($username)) {
        $self->setErrorMessage('Cannot create user: username is already in use');
        return 0;
    }

    my $userAddCommand = "useradd -m $username";
    my $userAddFailed = system($userAddCommand);

    die 'Cannot create user: an error has occurred and the command exited with code ' . $? >> 8 if $userAddFailed;

    my $uid = `id -u $username`;
    die 'Cannot create user: the system was unable to create the user and the command exited with code '. $? >> 8 if $? >> 8;

    `echo '$username:$password' | chpasswd`; # run command to add password to the user
    # in backticks or system won't execute it properly
    die 'Error when creating user: cannot add a password to the user and the command exited with code ' . $? >> 8 if $? >> 8;

    $persister->createCreatedByOsMonitorFile($username);
    
    return 1;
}

sub deleteUser {
    my ($self, $username, $userDeletionModel) = @_;
    if(!defined getpwnam($username)) {
        $self->setErrorMessage("Cannot delete user: user not found");
        return 0;
    }
    my $allUsers = $self->getAllUsers();
    my $escapedUsername = quotemeta($username);
    if(!grep($_->{username} =~ /\A$escapedUsername\z/ && $_->{isCreatedByOsMonitor}, @{$allUsers})) {
        $self->setErrorMessage("Cannot delete user: user not created by OSMonitoring");
        return 0;
    }
    my @command = ('userdel');
    push @command, ('-r', '-f') if $userDeletionModel->shouldDeleteHome();
    push @command, $username;
    system(@command);
    my $userdelExitCode = $? >> 8;
    return 1 if $userdelExitCode == 0;
    die 'Cannot delete user: an error has occurred and the command exited with code ' . $? >> 8;
    return 1;
}

sub getErrorMessage {
    my ($self) = @_;
    return $self->{errorMessage};
}

sub setErrorMessage {
    my ($self, $errorMessage) = @_;
    $self->{errorMessage} = $errorMessage;
    return 1;
}

1;