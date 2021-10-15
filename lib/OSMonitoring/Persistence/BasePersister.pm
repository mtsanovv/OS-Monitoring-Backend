package OSMonitoring::Persistence::BasePersister;

use Dancer2 appname => 'OSMonitoring';

use IO::File;
use OSMonitoring::Globals;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub readEtcPasswd {
    my ($self) = @_;
    my $etcPasswdFh = IO::File->new('/etc/passwd')
        or die "Cannot read /etc/passwd file: $!";
    my @etcPasswdLines = <$etcPasswdFh>;
    $etcPasswdFh->close()
         or die "Cannot close /etc/passwd file: $!";
    return @etcPasswdLines;
}

sub parseEtcPasswd {
    my ($self, @etcPasswdLines) = @_;
    my @usersList = ();
    foreach my $line (@etcPasswdLines) {
        chomp $line;
        my ($username, $passwordMask, $uid, $gid, $comments, $home, $shell) = split(/:/, $line);
        my $userDisplayName = (split(/,/, $comments))[0];
        my $isCreatedByOsMonitor = $self->createdByOsMonitorFileExists($home);
        my $userHash = {
            username => $username,
            uid => $uid,
            gid => $gid,
            displayName => $userDisplayName,
            home => $home,
            shell => $shell,
            isCreatedByOsMonitor => $isCreatedByOsMonitor
        };
        push @usersList, $userHash;
    }
    return \@usersList;
}

sub createdByOsMonitorFileExists {
    my ($self, $home) = @_;
    if(-f "$home/$CREATED_BY_OSMONITOR") {
        return 1;
    }
    return 0;
}

sub getAllUsers {
    my ($self) = @_;
    my @etcPasswdLines = $self->readEtcPasswd();
    my $usersList = $self->parseEtcPasswd(@etcPasswdLines);
    return $usersList;
}

1;