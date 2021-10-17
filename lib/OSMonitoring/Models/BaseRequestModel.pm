package OSMonitoring::Models::BaseRequestModel;

use Dancer2 appname => 'OSMonitoring';

sub new {
    my ($class, $data) = @_;
    die "Error when initializing $class: the request was not a JSON" if !ref $data;
    my $self = {
        data => $data
    };
    bless $self, $class;
}

sub validate {
    my ($self, $model) = @_;
    my $data = $self->getData();
    my $class = ref $self;
    foreach my $key(keys %{$model}) {
        if(!exists $data->{$key}) {
            error "Required model key $key does not exist when attempting to validate a model for $class";
            $self->setErrorMessage("Error when creating $class model: required key '$key' does not exist in the request JSON");
            return 0;
        }
        # key exists - we now need to validate its value
        my $regexValue = $model->{$key};
        my $regex = eval { qr/$regexValue/ };
        if(!defined $regex) {
            die "Invalid regex supplied for compilation: $regexValue";
        }
        if($data->{$key} !~ /$regex/) {
            error "Value for the key $key does not match $regexValue in the request JSON";
            $self->setErrorMessage("Error when creating $class model: Value for the key '$key' does not match $regexValue in the request JSON");
            return 0;
        }
        return 1;
    }
}

sub getData {
    my ($self) = @_;
    return $self->{data};
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