# dotfiles

## Management
To checkout this repo on a new system run:
1. `git clone --bare <git-repo-url> $HOME/.dotfiles`

2. Run `/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout`

3. Restart shell

4. Run `config config --local status.showUntrackedFiles no` to hide untracked files.

## Usage

Use the `config` alias as `git ...`
