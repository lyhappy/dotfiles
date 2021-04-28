# fish config

set fish_greeting

set -x GLFW_IM_MODULE ibus
set -x PATH "$PATH:$HOME/.stools:$HOME/code/dotfiles/bin:$HOME/.config/vifm/scripts"
set -x TERM "xterm-256color"

### Export ###
set -x EDITOR "nvim"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'" 

### aliases ###
alias vim='nvim'
alias vimdiff='nvim -d'

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias calendar='vim -c "Calendar"'
alias todo="vim $HOME/workspace/worknotes/todos/index.md"

function say 
	echo $argv | festival --tts
end

function proxy_on
	set -xg ALL_PROXY ""
end

function proxy_off
	set -xg ALL_PROXY ""
end

