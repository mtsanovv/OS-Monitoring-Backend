package OSMonitoring::Controllers::UserController;

use Dancer2 appname => 'OSMonitoring';

use OSMonitoring::Repositories::UserRepository;
use OSMonitoring::Models::Exception;
use OSMonitoring::Models::User;
use OSMonitoring::Models::UserDeletion;
use OSMonitoring::Globals;

prefix '/users' => sub {

    get '' => sub {
        logRequest(request->method(), request->path());
        my $userRepository = OSMonitoring::Repositories::UserRepository->new();
        my $allUsers = $userRepository->getAllUsers();
        return $allUsers;
    };

    post '' => sub {
        logRequest(request->method(), request->path());
        my $postedData = from_json(request->body());
        my $userModel = OSMonitoring::Models::User->new($postedData);
        if($userModel->validate()) {
            my $userRepository = OSMonitoring::Repositories::UserRepository->new();
            if($userRepository->createUser($userModel)) {
                status 201;
                return;
            }
            warning request->method() . ' request failed to ' . request->path();
            my $userCreationException = OSMonitoring::Models::Exception->new(400, $userRepository->getErrorMessage());
            status 400;
            return $userCreationException->getException();

        }
        warning request->method() . ' request failed to ' . request->path();
        my $userModelValidationException = OSMonitoring::Models::Exception->new(400, $userModel->getErrorMessage());
        status 400;
        return $userModelValidationException->getException();
    };

    del '/:username' => sub {
        logRequest(request->method(), request->path());
        my $username = params->{username};
        my $postedData = from_json(request->body());
        my $userDeletionModel = OSMonitoring::Models::UserDeletion->new($postedData);
        if($userDeletionModel->validate()) {
            my $userRepository = OSMonitoring::Repositories::UserRepository->new();
            if($userRepository->deleteUser($username, $userDeletionModel)) {
                status 204;
                return;
            }
            warning request->method() . ' request failed to ' . request->path();
            my $userDeletionException = OSMonitoring::Models::Exception->new(400, $userRepository->getErrorMessage());
            status 400;
            return $userDeletionException->getException();

        }
        warning request->method() . ' request failed to ' . request->path();
        my $userDeletionModelValidationException = OSMonitoring::Models::Exception->new(400, $userDeletionModel->getErrorMessage());
        status 400;
        return $userDeletionModelValidationException->getException();
    };

};

1;