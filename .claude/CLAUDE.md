# Preferences

- Avoid unnecessary comments. Only comment when the code is hard to understand without it, e.g. a non-obvious workaround or gotcha, never a restatement of what the code does.
- Always write commit messages in Conventional Commits style: `type(scope): summary`, e.g. `fix(restic): put sh on the agent PATH` or `chore(nix): drop redundant comments`.

# Dotfiles

- Dotfiles (including `~/.config/nix`) are tracked in a bare git repo at `~/.dotfiles` with work tree `$HOME`, remote `github.com/benjasper/dotfiles`. Those directories have no `.git` of their own.
- The zsh alias `config` is `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME` (`config-lazygit` for lazygit). Aliases aren't available in non-interactive shells, so spell out the full git command.
- `status.showUntrackedFiles=no`: new files don't show in status and must be added explicitly.
- Commit scope is the dotfile area, e.g. `feat(nix): add gcc`.
- `nix-switch` builds with cachix, switches, then shows `config diff ~/.config/nix/current-system-packages`.
