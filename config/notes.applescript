tell application "System Events"
    set obsidianRunning to (name of processes) contains "Obsidian"
    if obsidianRunning then
        tell process "Obsidian"
            set windowCount to count of windows
        end tell
    end if
end tell

if obsidianRunning and windowCount > 0 then
    tell application "Obsidian"
        activate
        return
    end tell
end if

do shell script "open -a Obsidian"
tell application "System Events"
    tell process "Obsidian"

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
