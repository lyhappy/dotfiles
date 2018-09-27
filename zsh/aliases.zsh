# reload zsh config
alias reload!='RELOAD=1 source ~/.zshrc'

# Filesystem aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # macOS `ls`
  colorflag="-G"
fi

alias l="ls -lah ${colorflag}"
alias la="ls -AF ${colorflag}"
alias ll="ls -lFh ${colorflag}"
alias lld="ls -l | grep ^d"
alias rmf="rm -rf"

# Helpers
alias grep='grep --color=auto'
alias df='df -h' # disk free, in Gigabytes, not bytes
alias du='du -h -c' # calculate disk usage for a folder

# grep aliases
alias phpgrep='find . -name "*.php" | xargs grep $2 -wn $3'
alias cgrep='find . -name "*.c|*.cc|*.cpp|*.h" | xargs grep $1 -wn'
alias javagrep='find . -name "*.java" | xargs grep $1 -wn'
alias tplgrep='find . -name "*.tpl" | xargs grep $1 -wn'

alias ping='ping -c 4 $1'
alias pign='ping $1'

# mirror for npm
alias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"

# IP addresses
alias localip="ipconfig getifaddr en1"
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i enp0s3 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""


# Recursively delete `.DS_Store` files
alias cleanup="find . -name '*.DS_Store' -type f -ls -delete"
# remove broken symlinks
alias clsym="find -L . -name . -o -type d -prune -o -type l -exec rm {} +"

# File size
alias fs="stat -f \"%z bytes\""

# open a chrome browser with security policies closed
alias unsafechrome="open -n /Applications/Google\ Chrome.app/ --args --disable-web-security --user-data-dir=/Users/luyao06/study/chrome/ &"

