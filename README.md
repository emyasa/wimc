# wimC

wimC is a lightweight Window Manager in C intended to run as a daemon for MacOS. It's main purpose is to map custom `cmd` hotkey combinations (i.e., numbers 1-9) to user defined applescripts. Upon installation, a config.yaml is initally provided in `~/.config/wimc/` directory, which can be updated accordingly. To restart the daemon, refer to the ff commands:
```
launchctl list | grep wimc
launchctl stop com.yasaworks.wimc
launchctl start com.yasawowrks.wimc
```

# Post Installation

Add `wimc`'s in the allowed application in `Accessibility`. To do so, refer to the ff steps:
1. Open `System Settings`.
2. Select `Privacy & Security` from the left sidebar.
3. Scroll down and select `Accessibility`.
4. If `wimc` is present, simply enable it.
   If not, click the `+` icon and add the `wimc` binary from `~/.local/bin/wimc`.
