package OSMonitoring::Controllers::HomeController;

use Dancer2 appname => 'OSMonitoring';

use OSMonitoring::Services::SystemStatsService;
use OSMonitoring::Globals;

get '/' => sub {
    logRequest(request->method(), request->path());
    status 204;
};

get '/stats' => sub {
    logRequest(request->method(), request->path());
    my $systemStatsService = OSMonitoring::Services::SystemStatsService->new();
    my $systemStats = $systemStatsService->getAllStatsPercentages();
    info "System stats fetched >>>>> cpu: $systemStats->{cpu}% ++++++ ram: $systemStats->{ram}% ++++++ swap: $systemStats->{swap}% ++++++ disk: $systemStats->{disk}%";
    return $systemStats;
};

1;