# bashrc: executed by bash(1) for non-login shells.

# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

add_to_path() {
  local new_entry=$1
  case ":$PATH:" in
    *":$new_entry:"*) :;; # already there
    *) PATH="$new_entry:$PATH";; # or PATH="$PATH:$new_entry"
  esac
  export PATH
}

# for vscode
workspaceFolder=~/analyser_workspace
export workspaceFolder

##############################################################
## SANE HISTORY DEFAULTS ##

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Record each line as it gets issued
PROMPT_COMMAND='history -a'

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Avoid duplicate entries
HISTCONTROL="ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Use standard ISO 8601 timestamp
# %F equivalent to %Y-%m-%d
# %T equivalent to %H:%M:%S (24-hours format)
HISTTIMEFORMAT='%F %T '

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'
# ok I love this too much
#bind '"\C-p": history-search-backward'
#bind '"\C_n": history-search-forward'

##############################################################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# expand dir when stored in env var
shopt -s direxpand

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [[ -z "$TMUX"  ]]; then
    export TERM='xterm-256color'
else
    export TERM='screen-256color'
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -AlFh --color'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Run twolfson/sexy-bash-prompt
. ~/.bash_prompt

# usefull function for bash utility
source /home/dev/.local/bin/bash_function.sh
source /home/dev/.local/bin/git_script.sh

add_to_path "/home/dev/bin/"
add_to_path "/home/dev/.local/bin/"

stty -ixon

# less is by default with case insensitive search
export LESS='-i'

# use vim by default everywhere. At least where they care.
export VISUAL=vim
export EDITOR="$VISUAL"

# as I have grant w access to all for ouroboros, this tweak avoid the ugly 'other writable' color
# but this was working on ubuntu, it didn't work since centos.
# eval "$(dircolors ~/.dircolors)";

# source env file from ouroboros
pushd ~/ouroboros > /dev/null
source .envrc css
popd > /dev/null
# completion broken by our envrc
if [[ ! -d "/mnt/remote_repo/other_repo/.oh-my-zsh/plugins/gitfast/" ]]; then
  sudo mount -a
fi
# ok it did not mount every time, but take ages so comment for now
#source /mnt/remote_repo/other_repo/.oh-my-zsh/plugins/gitfast/git-completion.bash

# usefull function for swint framework usage
# source /home/dev/.local/bin/swint_functions.sh

# if resource, multivio will be MONO by default, so update it according to the reserved rack
if [ -n "$(cs_getreservedrack)" ]; then
  _cs_set_rack_multi_vio
fi

# don't ask my why, without this git doesn't recognise clang-format...
# it is done in .envrc, but for no fucking reason, if I don't resource
# it here, git clang is not visible.........
export CS_ROOT=~/ouroboros
path_append "$TOOLS_ROOT/scripts/"
path_append "$CS_ROOT/.bin/"

# disable css linker diversification, cause meh, three time the compile
# is hard on my shoulder...
DISABLE_DIVERSIFICATION=1
export FAST_GENERATION=1

# use of powerline for bash prompt. Need a lot of tweaking to be used on convergence
# (add of rack state and git integration)
#. /opt/python2-venv/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh

# test with clipboard binding. Need xsel, don't have it.
# bind '"\C-p": "\C-e\C-u xsel <<"EOF"\n\C-y\nEOF\n\C-y"'

# source FZF, this is a general purpose fuzzy file finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPS="--extended"

# I don't understand shit to x forward
export DISPLAY=localhost:10.0

# use man of the current distrib of convergence target
export MANPATH=/opt/cc-distrib-snap-20230201/poky/sysroots/aarch64-poky-linux/usr/share/man/

m_debug_rust_analyzer() {
  # executing those lines seems to make rust analyzer work...
  cargo clippy --workspace --manifest-path /home/dev/ouroboros/reprog/Cargo.toml --target aarch64-unknown-linux-gnu --all-targets --all-features
}


export SWINT_LAYER=TRUE
export DEBUG_LAYER=debug-tools-small
#export TRAIN_PARAM=FORCED
export XAUTHORITY=~/.Xauthority

_cs_set_hosts_env

# to be sure to be in front, just redo it
export PATH="/opt/rust-1.60.0/bin:$PATH"
#export PATH="~/.cargo/bin/:$PATH"

# just to be sure, no duplicate in path
export PATH=$(echo "$PATH" | tr ":" "\n" | awk '!visited[$0]++' | tr "\n" ":")
