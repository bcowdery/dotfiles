#!/bin/bash

# system
export GREP_COLOR="1;33"
#alias grep="grep --color=auto"

alias ls="ls --color=always -X -p"

# vscleanup
alias vs-purge="rm -rf .vs/ && find ./ -name 'bin' -o -name 'obj' -type d | xargs rm -rf"
