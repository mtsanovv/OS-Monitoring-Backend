package OSMonitoring::Persistence::Persister;

use Dancer2 appname => 'OSMonitoring';

use POSIX;
use IO::File;
use File::HomeDir;
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
        my $userDisplayName = '';
        $userDisplayName = (split(/,/, $comments))[0] if length($comments);
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

sub createCreatedByOsMonitorFile {
    my ($self, $username) = @_;
    my $userHomeDir = File::HomeDir->users_home($username);
    my $createdByOsMonitorFile = "$userHomeDir/$CREATED_BY_OSMONITOR";
    my $createdByOsMonitorFileExists = $self->createdByOsMonitorFileExists($userHomeDir);
    if(!$createdByOsMonitorFileExists) {
        my $createdByOsMonitorFh = IO::File->new($createdByOsMonitorFile, 'w')
            or die "Error when creating user: cannot open $createdByOsMonitorFile: $!";
        print $createdByOsMonitorFh strftime("%Y-%m-%d %H:%M:%S\n", localtime time);
        $createdByOsMonitorFh->close()
            or die "Cannot close $createdByOsMonitorFile: $!";
        chmod 0444, $createdByOsMonitorFile;
    }
}

1;