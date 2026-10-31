# zsh theme
ZSH_THEME=""

# Set environment variables
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"

# Set path
export PATH="$HOME/.local/bin:$REX_BIN_DIR:/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/sbin:/opt/homebrew/opt/curl/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

export PATH="${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims:$PATH"

# Source .secrets.env
if [ -f ~/.secrets.env ]; then
	export $(grep -v '^#' "$HOME/.secrets.env" | xargs)
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Set default editor to neovim
export EDITOR="nvim"

if [[ -o interactive ]]; then
	# Antidote plugins: user installs, Homebrew (Apple Silicon/Intel), and Linux.
	() {
		local plugin_list="$HOME/.zsh_plugins.txt"
		local plugin_cache="$HOME/.zsh_plugins.zsh"
		local antidote_source candidate bundle_tmp

		if [[ -r "$plugin_list" && ( ! -s "$plugin_cache" || "$plugin_list" -nt "$plugin_cache" ) ]]; then
			for candidate in \
				"${ANTIDOTE_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/antidote}/antidote.zsh" \
				"$HOME/.antidote/antidote.zsh" \
				/opt/homebrew/opt/antidote/share/antidote/antidote.zsh \
				/run/current-system/sw/share/antidote/antidote.zsh \
				/usr/local/opt/antidote/share/antidote/antidote.zsh \
				/usr/share/zsh-antidote/antidote.zsh \
				/usr/share/antidote/antidote.zsh \
				/usr/local/share/antidote/antidote.zsh; do
				if [[ -r "$candidate" ]]; then
					antidote_source="$candidate"
					break
				fi
			done

			if [[ -n "$antidote_source" ]] && source "$antidote_source"; then
				zstyle ':antidote:static' zcompile yes
				if bundle_tmp=$(mktemp "${plugin_cache}.XXXXXX"); then
					if antidote bundle < "$plugin_list" >| "$bundle_tmp" && [[ -s "$bundle_tmp" ]]; then
						command mv -f -- "$bundle_tmp" "$plugin_cache"
					else
						command rm -f -- "$bundle_tmp"
						print -u2 'Antidote: bundle generation failed; keeping the existing cache.'
					fi
				fi
			else
				print -u2 'Antidote: installation not found; keeping any existing plugin cache.'
			fi
		fi

		[[ ! -s "$plugin_cache" ]] || source "$plugin_cache"
	}

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

	alias vim="nvim"
	alias ls="eza"

	alias zshconfig="nvim ~/.zshrc"
	alias dcu="docker compose up -d --pull=always"
	alias dcd="docker compose down"
	alias dce="docker compose exec webserver bash"
	alias dcp="docker compose exec php-fpm bash"
	alias encryptkey="ssh-keygen -p -o -f"
	alias encrypt-secrets="gpg --symmetric --cipher-algo AES256 ~/.secrets.env"
	alias decrypt-secrets="gpg --quiet --batch --decrypt ~/.secrets.env.gpg > ~/.secrets.env && chmod 600 ~/.secrets.env"
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

	# Determine the server identity once; Starship reads it without subprocesses.
	export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
	if [[ ${HOST%%.*} == personal-server ]]; then
		export STARSHIP_SERVER_IDENTITY="$USER@${HOST%%.*}"
	else
		unset STARSHIP_SERVER_IDENTITY
	fi
	eval "$(starship init zsh)"

	# zoxide
	eval "$(zoxide init --cmd cd zsh)"

	eval "$(mise activate zsh)"
fi
