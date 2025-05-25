# zsh theme
ZSH_THEME=""

# Set environment variables
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"

# Set path
export PATH="/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/sbin:/opt/homebrew/opt/curl/bin:$HOME/.local/bin:$PATH"
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
alias encrypt-secrets="gpg --symmetric --cipher-algo AES256 ~/.secrets.env"
alias decrypt-secrets="gpg --quiet --batch --decrypt ~/.secrets.env.gpg > ~/.secrets.env && chmod 600 ~/.secrets.env"
alias vim="nvim"
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias config-lazygit='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias git-clean-branches="git fetch -p ; git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -D"

alias nix-build="darwin-rebuild build --flake ~/.config/nix"
alias nix-update="nix flake update --flake ~/.config/nix"
alias nix-check-update="$aliases[nix-update] && $aliases[nix-build] && nix store diff-closures /var/run/current-system ~/.config/nix/result"
alias nix-switch="sudo darwin-rebuild switch --flake ~/.config/nix -v && $aliases[config] diff ~/.config/nix/current-system-packages"

# Copies terminfo to remote server. From https://ghostty.org/docs/help/terminfo#copy-ghostty's-terminfo-to-a-remote-machine
function ssh-copy-terminfo() {
    infocmp -x | ssh "$1" -- tic -x -
}

# Kills a process by taking the blocked port as an argument
function killport() {
    lsof -i tcp:"$1" | grep LISTEN | awk '{print $2}' | xargs kill
}

# Source .secrets.env
if [ -f ~/.secrets.env ]; then
	export $(grep -v '^#' "$HOME/.secrets.env" | xargs)
fi

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
