#Correcting backspace problems
export TERM=linux

HISTFILE=~/.config/realmenu/.history
HISTSIZE=40000
SAVEHIST=40000
setopt appendhistory autocd extendedglob nomatch notify hist_ignore_all_dups hist_ignore_space clobber COMPLETE_ALIASES
unsetopt beep
bindkey -e

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BNo matches found%b'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*' menu select
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

autoload -U promptinit
autoload -U colors && colors
promptinit
PROMPT='>'

fpath=(~/.config/zsh/completions $fpath)
autoload -U compinit && compinit

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# Set title to GNU screen/byobu tab
settitle() {
    if [ "$TERM" = "realmenu" ];
    then
        printf "\033k$1\033\\";
    fi
}

add-swaymsg() {
    NBUFFER="swaymsg exec \"$BUFFER\"; exit";
    eval "echo \"$BUFFER\" >> .config/realmenu/.history";
    eval "$NBUFFER";
    BUFFER="";
    zle .$WIDGET "$@";
}
zle -N accept-line add-swaymsg

zshaddhistory() {
   exit 2;
}

export KEYTIMEOUT=1
exit-shell() {
    exit;
}
zle -N exit-shell
bindkey '\e' exit-shell;

source ~/.aliases

if [ -r ~/.aliases.local ]; then
    source ~/.aliases.local
fi

source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#555555"
source $ZDOTDIR/zsh-autosuggestions/zsh-autosuggestions.zsh 2> /dev/null

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
