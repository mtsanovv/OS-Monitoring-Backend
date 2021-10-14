package OSMonitoring::Globals;

use Dancer2 appname => 'OSMonitoring';

use Exporter qw(import);

our @EXPORT = qw(logRequest $PROC_STAT_FILE_PATH $PROC_MEMINFO_FILE_PATH);

our $PROC_STAT_FILE_PATH = '/proc/stat';
our $PROC_MEMINFO_FILE_PATH = '/proc/meminfo';

sub logRequest {
    my ($method, $path) = @_;
    info "Received $method request to $path";
    return 1;
}

1;