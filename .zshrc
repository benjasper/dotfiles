# zsh theme
ZSH_THEME=""  # You can set this to a Zinit theme if desired

# Set environment variables
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# Override system curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export GOPATH="$HOME/go"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.9/libexec/bin:$PATH"
export PATH="${HOME}/.pyenv/shims:${PATH}"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

# Zinit installation check and setup
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit bundles (replace with modern alternatives)
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# Additional useful plugins
zinit light junegunn/fzf-bin  # Fuzzy finder
zinit light agkozak/zsh-z
zinit light zsh-users/zsh-history-substring-search

# FZF Initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# End of configuration

