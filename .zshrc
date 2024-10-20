# zsh theme
ZSH_THEME=""

# Set environment variables
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"

# Set path
export PATH="/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/sbin:/opt/homebrew/opt/curl/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Zinit installation check and setup (run only once)
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} Installing ZDHARMA-CONTINUUM Zinit plugin manager...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} Installation successful.%f%b" || \
        print -P "%F{160} Clone failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Zinit plugins
zinit light-mode for \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-completions \
    junegunn/fzf-bin \
    agkozak/zsh-z \
    zsh-users/zsh-history-substring-search

# FZF Initialization
source <(fzf --zsh)

# Aliases
setopt COMPLETE_ALIASES

alias zshconfig="nvim ~/.zshrc"
alias dcu="docker compose up -d --pull=always"
alias dcd="docker compose down"
alias dce="docker compose exec webserver bash"
alias dcp="docker compose exec php-fpm bash"
alias encryptkey="ssh-keygen -p -o -f"
alias vim="nvim"
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias nix-rebuild="darwin-rebuild switch --flake ~/.config/nix"
alias nix-update="nix flake update --flake ~/.config/nix"

function killport() {
    lsof -i tcp:"$1" | grep LISTEN | awk '{print $2}' | xargs kill
}

# Enable Volta pnpm support
export VOLTA_FEATURE_PNPM=1

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set default editor to neovim
export EDITOR="nvim"

# Starship prompt
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"
