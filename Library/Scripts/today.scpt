tell application "System Events" to if exists process "Things" then
    tell application "Things"
        tell list "Today"
            set nameList to {}
            repeat with todo in every to do whose status is equal to (open)
              set nameList to nameList & name of todo
            end repeat

            set oldDelimiter to AppleScript's text item delimiters
            set AppleScript's text item delimiters to "\n"
            set names to nameList as string
            set AppleScript's text item delimiters to oldDelimiter
            get names
        end tell
    end tell
end if
