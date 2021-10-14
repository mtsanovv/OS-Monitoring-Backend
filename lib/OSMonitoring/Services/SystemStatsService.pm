package OSMonitoring::Services::SystemStatsService;

use Dancer2 appname => 'OSMonitoring';

use POSIX qw(floor);
use IO::File;
use Filesys::Df;
use OSMonitoring::Globals;

sub new {
    my ($class) = @_;
    bless {}, $class;
}

sub readProcStatFile {
    my ($self) = @_;
    my $procStatFh = IO::File->new($PROC_STAT_FILE_PATH)
        or die "Cannot read file: $PROC_STAT_FILE_PATH: $!";
    my ($junk, $cpuUser, $cpuNice, $cpuSys, $cpuIdle) = split(/\s+/, <$procStatFh>);
    $procStatFh->close()
        or die "Cannot close file: $PROC_STAT_FILE_PATH: $!";
    return ($cpuUser, $cpuNice, $cpuSys, $cpuIdle);
}

sub readProcMemInfoFile {
    my ($self) = @_;
    my $procMemInfoFh = IO::File->new($PROC_MEMINFO_FILE_PATH)
        or die "Cannot read file: $PROC_MEMINFO_FILE_PATH: $!";
    
    my @requiredParams = qw(MemAvailable MemTotal SwapFree SwapTotal);
    my $requiredParamsString = join('|', @requiredParams);
    my @requiredParamsMemInfo = grep(/$requiredParamsString/, <$procMemInfoFh>);
    $procMemInfoFh->close()
        or die "Cannot close file: $PROC_MEMINFO_FILE_PATH: $!";
    my @requiredParamsValues = ();
    
    foreach my $requiredParam (sort @requiredParamsMemInfo) {
        my $requiredParamValue = (split(/\s+/, $requiredParam))[-2];
        push(@requiredParamsValues, $requiredParamValue);
    }

    return @requiredParamsValues; # since the params are sorted, they should be in the same order as in @requiredParams
}

sub getCpuUsage {
    my ($self) = @_;
    my ($cpuUser, $cpuNice, $cpuSys, $cpuIdle) = $self->readProcStatFile();
    my $firstCPUTotal = $cpuUser + $cpuNice + $cpuSys + $cpuIdle;
    my $firstCPULoad = $cpuUser + $cpuNice + $cpuSys;

    sleep(2);

    ($cpuUser, $cpuNice, $cpuSys, $cpuIdle) = $self->readProcStatFile();
    my $secondCPUTotal = $cpuUser + $cpuNice + $cpuSys + $cpuIdle;
    my $secondCPULoad = $cpuUser + $cpuNice + $cpuSys;

    my $deltaCPUTotal = $secondCPUTotal - $firstCPUTotal;
    my $deltaCPULoad = $secondCPULoad - $firstCPULoad;

    my $cpuUsage = $deltaCPULoad / $deltaCPUTotal;

    return $cpuUsage;
}

sub getMemUsage {
    my ($self) = @_;
    my ($ramAvail, $ramTotal, $swapAvail, $swapTotal) = $self->readProcMemInfoFile();

    my $ramUsage = 1 - $ramAvail / $ramTotal;
    my $swapUsage = 1 - $swapAvail / $swapTotal;

    return ($ramUsage, $swapUsage);
}

sub getDiskUsageInPercent {
    my ($self) = @_;
    my $df = df('/');

    return $df->{per};
}

sub getAllStatsPercentages {
    my ($self) = @_;
    my $cpuUsage = $self->getCpuUsage();
    my ($ramUsage, $swapUsage) = $self->getMemUsage();
    my $diskUsage = $self->getDiskUsageInPercent();

    my $statsPercentages = {
        cpu => $cpuUsage,
        ram => $ramUsage,
        swap => $swapUsage,
        disk => $diskUsage
    };

    foreach my $stat (keys %{$statsPercentages}) {
        my $statValue = $statsPercentages->{$stat};
        $statsPercentages->{$stat} = int($statValue * 100) if $statValue <= 1;
    }

    return $statsPercentages;
}

1;