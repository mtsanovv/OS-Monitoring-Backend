# OS-Monitoring-Backend
A simple Perl Dancer2 server that does some OS fiddling.

## Prerequisites
- Perl 5.30.0 (or you might try testing a new version)
- The following Perl modules: Dancer2, Starman, 

## Running the server
1. cd to the cloned repository
2. Execute ```plackup -s Starman bin/app.psgi``` to run the Dancer2 server. Alternatively, to have it run in background, you can execute ```screen plackup -s Starman bin/app.psgi```.

*M. Tsanov, 2021*