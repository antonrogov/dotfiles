# Log output:
#
# * 51c333e    (12 days)    <Gary Bernhardt>   add vim-eunuch
#
# The time massaging regexes start with ^[^<]* because that ensures that they
# only operate before the first "<". That "<" will be the beginning of the
# author name, ensuring that we don't destroy anything in the commit message
# that looks like time.
#
# The log format uses } characters between each field, and `column` is later
# used to split on them. A } in the commit subject or any other field will
# break this.

function pretty_git_log() {
  HASH="%CC(yellow)%h%CC(reset)"
  RELATIVE_TIME="%CC(green)(%ar)%CC(reset)"
  AUTHOR="%CC(blue)<%an>%CC(reset)"
  REFS="%CC(red)%d%CC(reset)"
  SUBJECT="%s"

  FORMAT="$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"

  git log --graph --pretty="tformat:${FORMAT}" $* |
    # Replace (2 years ago) with (2 years)
    sed -Ee 's/(^[^<]*) ago\)/\1\)/' |
    # Replace (2 years, 5 months) with (2 years)
    sed -Ee 's/(^[^<]*), [[:digit:]]+ .*months?\)/\1\)/' |
    # Line columns up based on } delimiter
    column -s '}' -t |
    sed "s/%CC(red)/$(printf '\e[31m')/" |
    sed "s/%CC(green)/$(printf '\e[32m')/" |
    sed "s/%CC(yellow)/$(printf '\e[33m')/" |
    sed "s/%CC(blue)/$(printf '\e[34m')/" |
    sed "s/%CC(reset)/$(printf '\e[0m')/g" |
    # Page only if we need to
    less -FXRS
}
