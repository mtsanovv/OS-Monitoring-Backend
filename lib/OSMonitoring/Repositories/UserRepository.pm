package OSMonitoring::Repositories::UserRepository;

use Dancer2 appname => 'OSMonitoring';

use OSMonitoring::Persistence::BasePersister;

sub new {
    my ($class) = @_;
    my $self = {
        persister => OSMonitoring::Persistence::BasePersister->new()
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

1;