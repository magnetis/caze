# ~/.bashrc: executed by bash(1) for non-login shells.
# This file configures some aliases and the prompt of
# our web container

export LS_OPTIONS='--color=auto'
export SHELL=/bin/bash
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias be='bundle exec'
alias rs='bundle exec rspec --color'
alias rspec='rspec --color'

export PS1="\u\[\e[32m\]@\[\e[m\]\[\e[33m\]\h\[\e[m\]:\w \[\e[36m\]⇒\[\e[m\] "
