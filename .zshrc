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

# Source .secrets.env
if [ -f ~/.secrets.env ]; then
	export $(grep -v '^#' "$HOME/.secrets.env" | xargs)
fi

# Enable Volta pnpm support
export VOLTA_FEATURE_PNPM=1

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set default editor to neovim
export EDITOR="nvim"

if [[ -o interactive ]]; then
	# Antidote plugins
	if [[ ! -s "$HOME/.zsh_plugins.zsh" || "$HOME/.zsh_plugins.txt" -nt "$HOME/.zsh_plugins.zsh" ]]; then
		source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
		zstyle ':antidote:static' zcompile yes
		antidote bundle < "$HOME/.zsh_plugins.txt" >| "$HOME/.zsh_plugins.zsh"
	fi
	source "$HOME/.zsh_plugins.zsh"

	autoload -Uz compinit
	compinit -C

	# FZF Initialization (cached)
	if command -v fzf >/dev/null 2>&1; then
		if [ ! -s "$HOME/.cache/fzf.zsh" ] || [ "$(command -v fzf)" -nt "$HOME/.cache/fzf.zsh" ]; then
			command mkdir -p "$HOME/.cache"
			fzf --zsh > "$HOME/.cache/fzf.zsh"
		fi
		[ -s "$HOME/.cache/fzf.zsh" ] && source "$HOME/.cache/fzf.zsh"
	fi

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

	alias nix-darwin-build='cachix watch-exec benjasper -- darwin-rebuild build --max-jobs 4 --flake "$HOME/.config/nix"'
	alias nix-clean="sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 30d && sudo nix-collect-garbage -d && nix store optimise"
	alias nix-update="nix flake update --flake ~/.config/nix"
	alias nix-switch='cachix watch-exec benjasper -- darwin-rebuild build --max-jobs 4 --flake "$HOME/.config/nix" -v && sudo darwin-rebuild switch --flake "$HOME/.config/nix" -v && config diff "$HOME/.config/nix/current-system-packages"'

	# Copies terminfo to remote server. From https://ghostty.org/docs/help/terminfo#copy-ghostty's-terminfo-to-a-remote-machine
	function ssh-copy-terminfo() {
		infocmp -x | ssh "$1" -- tic -x -
	}

	# Kills a process by taking the blocked port as an argument
	function killport() {
		lsof -i tcp:"$1" | grep LISTEN | awk '{print $2}' | xargs kill
	}

	# bun completions
	[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

	# Starship prompt
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	eval "$(starship init zsh)"

	# zoxide
	eval "$(zoxide init --cmd cd zsh)"
fi
