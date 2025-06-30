setopt extended_glob null_glob

# PATH=(
#   $HOME/bin
#   $HOME/.local/bin
#   $HOME/.cargo/bin
#   $HOME/.npm-global/bin
#   $HOME/scripts:$PATH
# )
#
# # Remove duplicate entries and non-existent directories
# typeset -U path
# path=($^path(N-/))
#
# export PATH

# SSH ------------------------------------------------------------------------------------
# To be set later

# Environment Variables ------------------------------------------------------------------------------------

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Set up superior editing mode

set -o vi

export VISUAL="nvim"
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export TERM="tmux-256color"
export BROWSER="firefox"
export PGHOST="/var/run/postgresql"
export PATH="$HOME/bin:$PATH"

# Directories

export PROJECTS="$HOME/projects"
export NOTES="$HOME/notes"
export GITUSER="Sidatii"
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$HOME/scripts"
export ZETTELKASTEN="$HOME/notes/zettelkasten"

# Rust related configurations

# export CARGO="usr/bin/cargo"
# export RUSTUP="$HOME/.rustup"
# export RUST="$CARGO/bin/rustc"

# Hisotry

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=50000

setopt HIST_IGNORE_SPACE # Do not save commands that start with a space
setopt HIST_IGNORE_DUPS # Do not save duplicate lines
setopt SHARE_HISTORY # Share history across all sessions

# ------------------------- Prompts --------------------------------

# THIS IS FOR USING PURE PROMPT INSTEAD OF STARSHIP
# PURE_GIT_PULL=0
# if [[ "SOSTYPE" == darwin* ]]; then
# fpath+=("$brew --prefix)/share/zsh/site-functions"
# else
# fpath+=($PATH/.zsh/pure)
# fi
#
#autoload -U promptinit; promptinit
#prompt pure


# ----------------------- Aliases -------------------------------

# Projects
alias agriin='nvim ~/projects/Platform-Back-end/src/main/java/com/audit/agriin/AgriInApplication.java'
# Notes
alias note='nvim ~/notes/personal/home.md'
# Cargo 
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'
alias cl='cargo clippy'
alias cfmt='cargo fmt'
alias cdoc='cargo doc --open'
alias ccheck='cargo check'
alias cclean='cargo clean'
alias crelease='cargo build --release'
# Nvim
alias n='nvim'
# System Navigation
alias ls='eza -lathr --color=always --long --git --group-directories-first --icons=always --no-user --no-time'
alias ll='ls -lathr --color=auto'
alias la='ls -la --color=auto'
alias c='clear'
alias cd='z'
# Frequent directories
alias scripts='cd $SCRIPTS'
alias dot='cd $DOTFILES'
# Docker
alias docker='lazydocker'
# Last modified files
alias lastmod='find . -type f -not -path "*/\.*" -exec ls -lrt {} +'
# Utilities
alias t='tmux'
alias e='exit'
alias syu='sudo pacman -Syu'
# Git
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'

# ~~~~~~~~~~~~~~~~~~~~~ Completion ~~~~~~~~~~~~~~~~~~~~~~

fpath+=~/.zfunc

#if type brew &>/dev/null; then
#  fpath+=($(brew --prefix)/share/zsh/site-functions)
#fi

# autoload -Uz compinit
# compinit -u

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# ---------------------- Sourcing ----------------------

# source "$HOME/.privaterc"
# [ -f ~/.fzf.zsh ] && 
# source ~/.fzf.zsh
# source <(fzf --zsh)

setopt inc_append_history
eval "$(fzf --zsh)"


# -------------------- FZF -----------------------

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -500'"

_fzf_compgen_path(){
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate list of directories for FZF completion
_fzf_compgen_dir(){
  fd --type=d --hidden --exclude .git . "$1"
}

_fzf_comprun(){
  local command=$1
  shift

  case $command in
    cd)
     fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset)
     fzf --preview "eval 'echo \$' {}" "$@" ;;
    ssh)
     fzf --preview 'dig {}'     "$@" ;;
    *) 
     fzf --preview "--preview 'bat -n --color=always --line-range :200 {}'" "$@" ;;
  esac
}

source ~/fzf-git.sh/fzf-git.sh
