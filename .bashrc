#!/usr/bin/env bash
#
# bashrc.sh
# Custom .bashrc additions for aws-ec2-fresh-install.
# Source this file from ~/.bashrc or copy its contents.
#
# Currently a placeholder — add your shell customizations here.
#!/usr/bin/env bash

# ====================== BASIC SETTINGS ======================
export EDITOR=micro
export VISUAL=micro

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# ====================== COLOR SUPPORT ======================
# Enable color for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ====================== COLORED PROMPT ======================
PS1='\[\e[1;32m\]\u@\h:\w\$\[\e[0m\] '

# Make sure we get 256 colors over SSH
export TERM=xterm-256color

# ====================== USEFUL ALIASES ======================
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# ====================== CUSTOM ADDITIONS ======================
# Add your own aliases, functions, or exports below this line
