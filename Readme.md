# dotfiles

## Start on a new system
To checkout this repo on a new system run:
1. `git clone --bare <git-repo-url> $HOME/.dotfiles`

2. Run `/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout`

3. Restart shell

4. Run `config config --local status.showUntrackedFiles no` to hide untracked files.

5. Install nix like this `https://nixos.org/download`

6. (Optional) In case new host: Configure new host in nix flake or change hostname (`scutil --get LocalHostName` to get current hostname)

7. Run `nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix` to install nix-darwin and install the configuration.

8. Run `decrypt-secrets` to decrypt secret environment variables.


## Usage

### Config changes

Use the `config` alias as `git ...`

### Rebuild nix configuration

Run `darwin-rebuild switch --flake ~/.config/nix`

### Updating packages

Run `nix flake update` and `darwin-rebuild switch --flake ~/.config/nix` afterwards.

## Upgrading MacOS

[Documentation](https://github.com/LnL7/nix-darwin/wiki/Upgrading-macOS)
