package OSMonitoring::Globals;

use Exporter qw(import);

our @EXPORT = qw($PROC_STAT_FILE_PATH $PROC_MEMINFO_FILE_PATH);

our $PROC_STAT_FILE_PATH = '/proc/stat';
our $PROC_MEMINFO_FILE_PATH = '/proc/meminfo';

1;