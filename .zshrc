# Get the shell evaluation context
[[ $ZSH_EVAL_CONTEXT == 'toplevel:file' ]];
file_being_sourced=$?

# Compinstall ================================================================

# The following lines were added by compinstall
#zstyle :compinstall filename '/home/ara/.zshrc'
#autoload -Uz compinit
#compinit
# End of lines added by compinstall

# ZPlug ======================================================================

source ~/.dotfiles/zplug/init.zsh

# Load Plugins (Handling some Crashes)
zplug "zsh-users/zsh-syntax-highlighting", defer:1, if:"[[ $file_being_sourced != 0 ]]"
zplug "zsh-users/zsh-history-substring-search", use:"./zsh-history-substring-search.zsh", on:"zsh-users/zsh-syntax-highlighting", if:"[[ $file_being_sourced != 0 ]]"
zplug "~/.dotfiles/zsh-autosuggestions", from:local, use:"./zsh-autosuggestions.zsh", defer:2
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/compleat", from:oh-my-zsh
zplug "plugins/git-extras", from:oh-my-zsh
zplug "hchbaw/zce.zsh", from:github, use:"./zce.zsh"
zplug "mafredri/zsh-async", from:github, use:"./async.zsh"
zplug "Tarrasch/zsh-functional", from:github, use:"./functional.plugin.zsh"
zplug "psprint/ztrace", from:github, use:"./ztrace.plugin.zsh"
#zplug "psprint/zsh-editing-workbench", from:github, use:"./zsh-editing-workbench.plugin.zsh"
#zplug "psprint/zsh-navigation-tools", from:github, use:"./zsh-navigation-tools.plugin.zsh"
#zplug "psprint/zsh-cmd-architect", from:github, use:"./zsh-cmd-architect.plugin.zsh"
zplug "Tarrasch/zsh-autoenv", from:github, use:"./init.sh"
zplug "b4b4r07/enhancd", from:github, use:"./init.sh"

# Load OMZ
zplug "robbyrussell/oh-my-zsh", use:"./lib/*.zsh"

# Load Theme
zplug "~/.dotfiles/themes/", from:local, use:"recursion_pure.zsh-theme", defer:3

# Install Plugins
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# Additional Configuration ===================================================

# History Configuration
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Matching Configuration
setopt autocd extendedglob nomatch notify

# No Beep
unsetopt appendhistory beep

# Keymap
bindkey -v
KEYTIMEOUT=1

# Enhancd Configuration
export ENHANCD_DOT_ARG=0

# History Substring Search Keybindings
zmodload zsh/terminfo
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# ZSH Autosuggestions Configuration
bindkey "^ " autosuggest-accept
bindkey "^H" autosuggest-clear
#bindkey "^M" autosuggest-execute
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=blue'

# FZF Keybindings and Completions
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# Timezone
export TZ="Europe/London"

# Basic Tool Setup
export EDITOR=vim
export PAGER="less -R"

# Vim Configuration
alias vimrc="vim ~/.vimrc"
alias vi="vim"

# Generic Utility Aliases
alias nettest="ping 8.8.8.8"
alias zshrc="vim ~/.zshrc"
alias reload="source ~/.zshrc"

# Grep Aliases
alias grep="grep -inT"
alias grepc="grep -color=always"
alias grepx="grep -C 2"

# Navigation Aliases
alias ll="ls -lh --color --group-directories-first"
alias lll="ls -lah --color --group-directories-first"
alias lld="ls -lah -d ./ --color --group-directories-first"
alias cdh="cd ~/"
alias cdo="cd ~/OneDrive"
alias u="cd .."

# Git Aliases
alias gd="git diff"
alias gdt="git difftool"
alias gb="git branch -va"

# Tmux Utility Functions
function redisp() {
    if [ -n "$TMUX" ]; then
        eval "export $(tmux show-environment DISPLAY)"
    fi
}

# Clock Utility Functions
function clock() {
    sudo systemctl stop ntpd;
    sudo systemctl start ntpd;
}

# Dircolors
eval `dircolors ~/.dotfiles/dircolors-solarized/dircolors.256dark`

# Input Control
autoload zkbd
[[ ! -f ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE} ]] && zkbd
source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

# Fancy Ctrl+Z
fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
