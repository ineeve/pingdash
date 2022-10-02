# PingDash

Simple cross-platform app to monitor multiple remote systems using the operating system ping command.


If there's an ICMP timeout, the system will sound an alarm (only available on the desktop app). The alarm can be configured per system. 


Thanks to $dart_ping for making this possible.

## Download
- Linux: The app is available through the snapstore

## Donations
https://www.buymeacoffee.com/ineeve


## Development instructions
Contributions are welcomed via pull requests.
1. Install flutter
2.`flutter run`

### LINUX build (Snap)
1. `snapcraft` - build and package
2. `snapcraft login`
3. `snapcraft upload --release=<channel> <file>.snap`

