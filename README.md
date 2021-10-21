# OS-Monitoring-Backend
A Perl REST API that monitors Linux OS status & manages users. This is the backbone of [OS-Monitoring-Frontend](https://github.com/mtsanovv/OS-Monitoring-Frontend).

## Prerequisites
- Perl 5.30.0 (or you might try testing a new version)
- The following Perl modules: Dancer2, Dancer2::Logger::Log4perl, Starman, Filesys::Df, File::HomeDir
- root access

## Running the Dancer2 server
1. Navigate to the directory of the cloned repository.
2. Make sure you're root (if possible). If you're not root, you should run all the commands below with a sudo prefix in order to escalate privileges (in order for the app to be able to access specific OS aspects). **Additionally, with non-root access, the application may not function properly.**
3. Execute ```plackup -s Starman bin/app.psgi``` to run the Dancer2 server. Alternatively, to have it run in background, you can execute ```screen plackup -s Starman bin/app.psgi```.

*M. Tsanov, 2021*