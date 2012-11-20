on run argv
  tell application "System Events" to if exists process "Things" then
      tell application "Things"
          set d to current date
          repeat until d's weekday is Monday
            set d to d - days
          end repeat

          if length of argv > 1 and item 2 of argv equals "more" then
            set d to d - days
            repeat until d's weekday is Monday
              set d to d - days
            end repeat
          end if

          if length of argv > 2 and item 3 of argv equals "more" then
            set d to d - days
            repeat until d's weekday is Monday
              set d to d - days
            end repeat
          end if

          set time of d to 0

          set areaName to item 1 of argv
          tell area areaName
            set nameList to {}
            set total to 0
            set pomodoroTags to items of "12345678"
            set k to 1.6

            repeat with todo in every to do whose completion date is greater than or equal to d
              repeat with aTag in tags of todo
                set aName to name of aTag
                if pomodoroTags contains aName then
                  set total to total + aName
                  set completedAt to completion date of todo
                  set completedYear to year of completedAt as integer
                  set completedMonth to month of completedAt as integer
                  if completedMonth < 10 then
                    set completedMonth to "0" & completedMonth
                  end if
                  set completedDay to day of completedAt
                  if completedDay < 10 then
                    set completedDay to "0" & completedDay
                  end if
                  set completedDate to completedYear as string & "-" & completedMonth as string & "-" & completedDay as string
                  set aName to completedDate & " - " & aName & " (" & (aName * k) & "h) - " & name of todo
                  set nameList to nameList & aName
                  exit repeat
                end if
              end repeat
            end repeat

            set total to total as string

            set oldDelimiter to AppleScript's text item delimiters
            set AppleScript's text item delimiters to "\n"
            set names to nameList as string
            set names to {"total: " & total & " (" & (total * k) & " hours)", names} as string
            set AppleScript's text item delimiters to oldDelimiter
            get names
          end tell
      end tell
  end if
end run
