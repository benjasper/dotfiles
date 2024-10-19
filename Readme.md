# dotfiles

## Management
To checkout this repo on a new system run:
1. `git clone --bare <git-repo-url> $HOME/.dotfiles`

2. Run `/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout`

3. Restart shell

4. Run `config config --local status.showUntrackedFiles no` to hide untracked files.

5. Run `nix run nix-darwin -- switch --flake ~/.config/nix` to install nix-darwin and install the configuration.

## Usage

Use the `config` alias as `git ...`

### Rebuild nix configuration

Run `darwin-rebuild switch --flake ~/.config/nix-darwin`

### Updating packages

Run `nix flake update` and `darwin-rebuild switch --flake ~/.config/nix-darwin` afterwards.
