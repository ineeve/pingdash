# PingDash

Simple cross-platform app to monitor multiple remote systems using the operating system ping command.


If there's an ICMP timeout, the system will sound an alarm (only available on the desktop app). The alarm can be configured per system. 

![screenshot](snap/gui/pingdash-screenshot.png)


## Download
- Linux: The app is available through the [snapstore](https://snapcraft.io/pingdash)

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

## Credits
Thanks to [dart_ping](https://pub.dev/packages/dart_ping) for making this project possible.
