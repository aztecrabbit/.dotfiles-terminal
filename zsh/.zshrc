#!/bin/sh

get_distribution()
{
    if [ ! -f /etc/os-release ]; then
        echo "android"
    fi

    grep -E "^ID=" /etc/os-release | cut -d "=" -f 2
}


# Install Antigen
#

if [ "$UID" != "0" ] && [ ! -f "$HOME/.antigen.sh" ]; then
    curl -L git.io/antigen-nightly > $HOME/.antigen.sh && chmod +x $HOME/.antigen.sh
fi

if [ ! -f "$HOME/.antigen.sh" ]; then
    echo "Antigen not found!"
    return
fi

source $HOME/.antigen.sh


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
antigen bundle virtualenvwrapper

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# Themes

if [ "$(get_distribution)" = "android" ]; then
    antigen theme aztecrabbit/zsh-themes themes/aztecrabbit-termux
else
    antigen theme aztecrabbit/zsh-themes themes/aztecrabbit
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
alias ll="ls -l"
alias la="ll -a"
alias lt="ll --tree --level=2"

# Docker Compose

alias dcub="docker-compose up --build"

# Alias Finder

af () {
    alias | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} "$*"
}


# Private
#

[ -f ~/.zshrc-private ] && source ~/.zshrc-private
