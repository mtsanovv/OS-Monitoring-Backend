package OSMonitoring::Controllers::UserController;

use Dancer2 appname => 'OSMonitoring';

use OSMonitoring::Repositories::UserRepository;
use OSMonitoring::Models::Exception;
use OSMonitoring::Globals;

prefix '/users' => sub {

    get '' => sub {
        logRequest(request->method(), request->path());
        my $userRepository = OSMonitoring::Repositories::UserRepository->new();
        my $allUsers = $userRepository->getAllUsers();
        return $allUsers;
    };

};

1;