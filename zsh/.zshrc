get_distribution() {
  if [ ! -f /etc/os-release ]; then
    echo "android"
    return 0
  fi

  grep -E "^ID=" /etc/os-release | cut -d "=" -f 2
}

# Install Antigen
#

install_antigen() {
  curl -L git.io/antigen-nightly > $HOME/.antigen.zsh
}

if [ "$UID" != "0" ] && [ ! -f "$HOME/.antigen.zsh" ]; then
  install_antigen
fi

if [ ! -f "$HOME/.antigen.zsh" ]; then
  echo "Antigen not found!"
  return 1
fi

source $HOME/.antigen.zsh


# Antigen
#

antigen use oh-my-zsh

# Aliases

antigen bundle adb
antigen bundle docker
antigen bundle docker-compose
antigen bundle git
antigen bundle golang
antigen bundle history
antigen bundle systemd
antigen bundle tmux
antigen bundle vscode

# Completion

antigen bundle heroku
antigen bundle pip
antigen bundle ufw

# Plugins

antigen bundle colored-man-pages
antigen bundle command-not-found
antigen bundle git-flow
antigen bundle gitfast
antigen bundle gitignore
antigen bundle man
antigen bundle postgres
antigen bundle profiles
antigen bundle sudo
antigen bundle transfer
# antigen bundle virtualenvwrapper

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# Themes

hostname="$(hostname)"

if [ "$(get_distribution)" = "android" ]; then
  antigen theme aztecrabbit/zsh-themes themes/aztecrabbit-simple
else
  if [ "$hostname" = "home" ] || [ "$hostname" = "laptop" ]; then
    antigen theme aztecrabbit/zsh-themes themes/aztecrabbit
  else
    antigen theme aztecrabbit/zsh-themes themes/server
  fi
fi

antigen apply


# Plugins Configurations
#

typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[alias]='fg=white'
ZSH_HIGHLIGHT_STYLES[command]='fg=white'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
ZSH_HIGHLIGHT_STYLES[function]='fg=white'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=red"


# Aliases
#

alias ls="ls --color=auto --group-directories-first --literal --time-style '+%b %d %Y %H:%m'"
alias ll="ls -l --human-readable"

# Alias Finder

a() {
  alias | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} "$*"
}

# Antigen

antigen_update() {
  source ~/.antigen.zsh && eval antigen update
}

# Dotfiles

alias dotfiles="cd ~/.dotfiles && git status -s -u"
alias dotfiles-private="cd ~/.dotfiles-private && git status -s -u"
alias dotfiles-terminal="cd ~/.dotfiles-terminal && git status -s -u"

# Docker

docker_clear() {
  containers="$(docker ps -qa)"
  if [ ! -z "$containers" ]; then
    echo $containers | xargs docker rm
  fi

  images="$(docker images | grep '<none>' | awk '{ print $3 }')"
  if [ ! -z "$images" ]; then
    echo $images | xargs docker rmi
  fi
}

# Docker Compose

dcupgrade() {
  docker-compose pull
  docker-compose down
  docker-compose up -d
}

dcupbdn() {
  docker-compose up --build
  docker-compose down
}

dcef() {
  docker-compose -f "$1" exec ${*:2}
}

dcupbf() {
  docker-compose -f "$1" up --build ${*:2}
}

dcupbdnf() {
  docker-compose -f "$1" up --build ${*:2}
  docker-compose -f "$1" down
}

dcupbdf() {
  docker-compose -f "$1" up --build -d ${*:2}
}

dcdnf() {
  docker-compose -f "$1" down ${*:2}
}

# Git

alias gss="git status -s -u"

# Mega

mega_progress() {
  while true; do
    clear && mega-transfers --limit=32
    sleep 2
  done
}

# Mosh

alias mosh="mosh --ssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"

# Nmcli

nmcli_refresh() {
  nmcli dev wifi list --rescan yes
}

nmcli_reload() {
  nmcli net off
  nmcli net on

  sleep 1

  nmcli_refresh
}

# Openssh

alias ssh="TERM=xterm-256color ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Stable Diffusion

alias stable-diffusion="cd ~/Stable\ Diffusion && ./webui.sh; cd ~"

# Vim

alias sudovim="sudo --preserve-env vim"
alias tconf="vim ~/.tmux.conf"
alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"

# Virtual Environment Wrapper

source_virtualenvironmentwrapper() {
  if [[ -a "/usr/bin/virtualenvwrapper.sh" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export PROJECT_HOME="$HOME/Virtual Environment"
    export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"
    export VIRTUALENVWRAPPER_VIRTUALENV_ARGS=" -p /usr/bin/python3"

    source /usr/bin/virtualenvwrapper.sh
  fi
}


# Applications
#

# Cmd

cmd_get_file() {
  mkdir -p ~/.cmd

  echo ~/.cmd/$(echo "${1// /-}")
}

cmd_set() {
  vim $(cmd_get_file "$1") -c ":set syntax=bash" ${*:2}
}

cmd_get() {
  if [ -z "$1" ] ; then
    ls $(cmd_get_file "$1") -1 --color=no 2>/dev/null | column
    return 0
  fi

  file=$(cmd_get_file "$1")

  if [ -f "$file" ] ; then
    cat $file
  fi
}

cmd_del() {
  file=$(cmd_get_file "$1")

  if [ -f "$file" ] ; then
    echo "Deleting $file"
    echo "Enter to continue ..."
    read

    rm -f $file
  fi
}

cmd() {
  if [ -z "$1" ] ; then
    cmd_get
    return 0
  fi

  file=$(cmd_get_file "$1")

  if [ -f "$file" ] ; then
    chmod +x $file
    bash -c "$file $(echo ${@:2})"

  else
    echo "Command \"$1\" not found!"
  fi
}

# Notes

notes() {
  if [ "$*" = "ls" ] ; then
    ls ~/.notes* -1 --color=no 2>/dev/null
    return 0
  fi

  if [ "$*" ] ; then
    vim ~/.notes-$(echo "${*// /-}" | tr "[:upper:]" "[:lower:]")
  else
    vim ~/.notes
  fi
}


# Path
#

PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$HOME/go/bin"

EDITOR=vim

# Private
#

[ -f ~/.zshrc-private ] && source ~/.zshrc-private


#
#

