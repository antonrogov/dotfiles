direnv-load() {
  direnv allow;
  trap -- '' SIGINT;
  eval "$(direnv export zsh)";
  trap - SIGINT;
}
