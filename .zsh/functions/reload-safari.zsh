function reload-safari() {
  osascript -e '
  tell application "Safari"
    activate
    tell current tab of front window
      do JavaScript "window.location.reload()"
    end tell
  end tell
  '
}
