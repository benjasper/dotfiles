# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# zsh theme
ZSH_THEME=""

zstyle ':omz:update' mode auto # update automatically without asking

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export GOPATH="$HOME/go"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH=/opt/homebrew/opt/python@3.9/libexec/bin:$PATH
export PATH="${HOME}/.pyenv/shims:${PATH}"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

# Load Antigen
source /opt/homebrew/share/antigen/antigen.zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle docker
antigen bundle docker-compose
antigen bundle command-not-found
antigen bundle sunlei/zsh-ssh

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Tell Antigen that you're done.
antigen apply

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Aliases
alias zshconfig="nvim ~/.zshrc"
alias dcu="docker compose up -d --pull=always"
alias dcd="docker compose down"
alias dce="docker compose exec webserver bash"
alias dcp="docker compose exec php-fpm bash"
alias encryptkey="ssh-keygen -p -o -f"
alias vim="nvim"
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function killport() {
	lsof -i tcp:"$1" | grep LISTEN | awk '{print $2}' | xargs kill
}

# bun completions
[ -s "$HOME.bun/_bun" ] && source "$HOME.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set default editor to neovim
export EDITOR="nvim"

# Pure theme
fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure
