tell application "System Events"
    set notesRunning to (name of processes) contains "Notes"
    if notesRunning then
        tell process "Notes"
            set windowCount to count of windows
        end tell
    end if
end tell

if notesRunning and windowCount > 0 then
    tell application "Notes"
        activate
        return
    end tell
end if

do shell script "open -a Notes"
tell application "System Events"
    tell process "Notes"

        repeat until (count of windows) > 0
            delay 0.01
        end repeat

        tell application "Finder"
            set screenBounds to bounds of window of desktop
        end tell

        set screenWidth to item 3 of screenBounds
        set screenHeight to item 4 of screenBounds

        set targetWidth to screenWidth / 3
        set targetX to screenWidth - targetWidth
        set targetY to 0

        tell front window
            set position to {targetX, targetY}
            set size to {targetWidth, screenHeight}
        end tell
    end tell
end tell
