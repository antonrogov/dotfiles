# use AppleScript to communicate with the Pomodoro application on OSX
function pomodoro() {
  case $1 in
    start)
      osascript -e "tell app \"Pomodoro\" to start \"$2\" duration 25 break 5"
      ;;
    stop)
      osascript -e "tell app \"Pomodoro\" to reset"
      ;;
    pause)
      osascript -e "tell app \"Pomodoro\" to external interrupt"
      ;;
    resume)
      osascript -e "tell app \"Pomodoro\" to resume"
      ;;
    list)
      osascript ~/Library/Scripts/today.scpt
      ;;
    stats)
      osascript ~/Library/Scripts/stats.scpt $2 $3 $4 | sort
      ;;
    *)
      echo "${0} start {task desc}|stop|pause|resume|list|stats {area name} [more]"
  esac
}
