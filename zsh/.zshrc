#!/bin/sh

get_distribution()
{
    if [ ! -f /etc/os-release ]; then
        echo "android"
        return 0
    fi

    grep -E "^ID=" /etc/os-release | cut -d "=" -f 2
}


# Install Antigen
#

if [ "$UID" != "0" ] && [ ! -f "$HOME/.antigen.zsh" ]; then
    curl -L git.io/antigen-nightly > $HOME/.antigen.zsh
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

if [ "$(get_distribution)" = "android" ]; then
    antigen theme aztecrabbit/zsh-themes themes/aztecrabbit-simple
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
alias ll="ls -l --human-readable"

# Dotfiles

alias dotfiles="cd ~/.dotfiles && git status -s -u"
alias dotfiles-private="cd ~/.dotfiles-private && git status -s -u"
alias dotfiles-terminal="cd ~/.dotfiles-terminal && git status -s -u"

# Django

django_start () {
	DJANGO_DEBUG=0 DJANGO_ALLOWED_HOSTS='*' python manage.py runserver $*
}

django_start_debug () {
	DJANGO_DEBUG=1 DJANGO_ALLOWED_HOSTS='*' python manage.py runserver $*
}

django_start_gunicorn () {
	DJANGO_DEBUG=0 DJANGO_ALLOWED_HOSTS='*' gunicorn web.wsgi:application --bind $*
}

# Docker

docker_clear () {
	containers="$(docker ps -qa)"
	if [ ! -z "$containers" ]; then
		echo $containers | xargs docker rm
	fi

	images="$(docker images | grep '^<none>' | awk '{ print $3 }')"
	if [ ! -z "$images" ]; then
		echo $images | xargs docker rmi
	fi
}

# Docker Compose

alias dcf="docker-compose -f"
alias dcupb="docker-compose up --build"
alias dcupbd="docker-compose up --build -d"

dcupbdn () {
	docker-compose up --build
	docker-compose down
}

dcef () {
	docker-compose -f "$1" exec ${*:2}
}

dcupbf () {
	docker-compose -f "$1" up --build ${*:2}
}

dcupbdnf () {
	docker-compose -f "$1" up --build ${*:2}
	docker-compose -f "$1" down
}

dcupbdf () {
	docker-compose -f "$1" up --build -d ${*:2}
}

dcdnf () {
	docker-compose -f "$1" down ${*:2}
}

# Go-Lang

alias gobs="go build -ldflags '-s -w'"
alias gobss="go build -ldflags '-s -w -linkmode external -extldflags -static'"

# Openssh

alias ssh-ignore="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

# Git

alias gss="git status -s -u"

gclgh () {
    git clone --recurse-submodules https://github.com/$*
}

gclgl () {
    git clone --recurse-submodules https://gitlab.com/$*
}

# Alias Finder

a () {
    alias | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} "$*"
}

# Vim

alias zshrc="vim ~/.zshrc"

# Notes

notes () {
	if [ "$*" = "ls" ] ; then
		ls -1 ~/.notes*
		return 0
	fi

	if [ "$*" ] ; then
		vim ~/.notes-$(echo "${*// /-}" | tr "[:upper:]" "[:lower:]")
	else
		vim ~/.notes
	fi
}

# Private
#

[ -f ~/.zshrc-private ] && source ~/.zshrc-private

return 0
