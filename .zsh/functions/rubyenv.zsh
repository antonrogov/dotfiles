function rubyenv() {
  home=/Users/anton/.rbenv/envs

  case $1 in
    activate)
      if [ -z $2 ]; then
        echo "Usage: rubyenv activate NAME"
        exit 1
      fi

      env="$home/$2"
      mkdir -p $env

      if [[ -z "$_OLD_GEM_HOME" && -z "$_OLD_GEM_PATH" && -z "$_OLD_PATH" ]]; then
        export _OLD_GEM_HOME=$GEM_HOME
        export _OLD_GEM_PATH=$GEM_PATH
        export _OLD_PATH=$PATH
      fi

      export GEM_HOME=$env
      export GEM_PATH=$env
      export PATH=$env/bin:$PATH
      rehash
      ;;

    deactivate)
      if [ -n "$_OLD_GEM_HOME" ]; then
        export GEM_HOME="$_OLD_GEM_HOME"
      else
        unset GEM_HOME
      fi
      unset _OLD_GEM_HOME

      if [ -n "$_OLD_GEM_PATH" ]; then
        export GEM_PATH="$_OLD_GEM_PATH"
      else
        unset GEM_PATH
      fi
      unset _OLD_GEM_PATH

      if [ -n "$_OLD_PATH" ]; then
        export PATH="$_OLD_PATH"
      else
        unset PATH
      fi
      unset _OLD_PATH
      rehash
      ;;

    *)
      echo "Usage: rubyenv activate NAME or rubyenv deactivate"
  esac
}

alias ra='rubyenv activate'
alias rd='rubyenv deactivate'
alias rl='ls -1 ~/.rbenv/envs'
