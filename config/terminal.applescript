tell application "System Events"
    set ghosttyRunning to (name of processes) contains "Ghostty"
    if ghosttyRunning then
        tell process "Ghostty"
            set windowCount to count of windows
        end tell
    end if
end tell

if ghosttyRunning and windowCount > 0 then
    tell application "Ghostty"
        activate
        return
    end tell
end if

do shell script "open -a Ghostty"
tell application "System Events"
    tell process "Ghostty"

        repeat until (count of windows) > 0
            delay 0.01
        end repeat

        tell application "Finder"
            set screenBounds to bounds of window of desktop
        end tell

        set screenWidth to item 3 of screenBounds
        set screenHeight to item 4 of screenBounds

        set targetWidth to screenWidth
        set targetX to screenWidth - targetWidth
        set targetY to 0

        tell front window
            set position to {targetX, targetY}
            set size to {targetWidth, screenHeight}
        end tell

        keystroke "tmux new -A -s session"
        key code 36 -- Enter
    end tell
end tell
