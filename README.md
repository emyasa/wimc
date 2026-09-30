# wimC

wimC is a lightweight Window Manager in C inteded to run as a daemon for MacOS. It's main purpose is to map custom `cmd` hotkey combinations (i.e., numbers 1-9) to user defined applescripts. Upon installation, a config.yaml is initally provided in `~/.config/wimc/` directory, which can be updated accordingly. To restart the daemon, referto the ff commands:
```
launchctl list | grep wimc
launchctl stop com.yasaworks.wimc
launchctl start com.yasawowrks.wimc
```
