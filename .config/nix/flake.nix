{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      commonSystemPackages = pkgs: [
        # Development
        pkgs.git
        pkgs.lazygit
        pkgs.neovim
        pkgs.kitty
        pkgs.zoxide
        pkgs.starship
        pkgs.maccy
        pkgs.fd
        pkgs.ripgrep
        pkgs.fzf
        pkgs.nerdfonts
        pkgs.bruno
        pkgs.zed
        pkgs.sqlite

        # Languages
        pkgs.go
        pkgs.go-task
        pkgs.php
        pkgs.rustup
        pkgs.lua

        # Language Servers and Language Tools
        pkgs.nodePackages."@astrojs/language-server"
        pkgs.biome
        pkgs.clang-tools
        pkgs.delve
        pkgs.gitlab-ci-ls
        pkgs.gopls
        pkgs.intelephense
        pkgs.lua-language-server
        pkgs.nixfmt-rfc-style
        pkgs.nodePackages.graphql-language-service-cli
        pkgs.nil
        pkgs.prettierd
        pkgs.stylua
        pkgs.sqls
        pkgs.tailwindcss-language-server
        pkgs.taplo
        pkgs.templ
        pkgs.typescript-language-server
        pkgs.vscode-langservers-extracted # Contains HTML, CSS, ESLint and JSON
        pkgs.yaml-language-server
        pkgs.zls

        # Tools
        pkgs.obsidian
      ];

      commonCasks = [
        "google-chrome"
        "firefox"
        "raycast"
        "tableplus"
        "maccy"
        "linearmouse"
        "docker"
      ];

      baseConfiguration =
        { pkgs, ... }:
        {
          # Cannot be installed with nix packages
          homebrew = {
            brews = [
              "volta"
            ];
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          # Fonts
          fonts.packages = with pkgs; [
            # Only install the Nerd Fonts Symbols Only
            (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
          ];

          # Set system settings.
          system = {
            defaults = {
              loginwindow.GuestEnabled = false;
              dock.autohide = true;
              dock.minimize-to-application = true;
              dock.show-recents = false;
              trackpad.Clicking = false;
              finder.AppleShowAllExtensions = true;
              finder.AppleShowAllFiles = true;
              NSGlobalDomain.KeyRepeat = 2;
              NSGlobalDomain.AppleInterfaceStyle = "Dark";
            };

            keyboard.enableKeyMapping = true;
            keyboard.remapCapsLockToEscape = true;
          };

          nixpkgs.config.allowUnfree = true;

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          # Write the current system packages to /etc/current-system-packages including their versions
          environment.etc."current-system-packages".text =
            let
              # Extract the package names from environment.systemPackages
              packages = builtins.map (p: "${p.name}") (commonSystemPackages pkgs);

              # Sort and remove duplicates
              sortedUnique = pkgs.lib.lists.unique (builtins.sort builtins.lessThan packages);

              # Format as a newline-separated string
              formatted = builtins.concatStringsSep "\n" sortedUnique;
            in
            formatted;
        };

      personalConfiguration =
        { pkgs, ... }:
        {
          environment.systemPackages = commonSystemPackages pkgs;
          homebrew = {
            enable = true;
            casks = commonCasks ++ [
              "1password"
              "discord"
            ];
            onActivation.cleanup = "zap";
          };
        };

      workConfiguration =
        { pkgs, ... }:
        {
          environment.systemPackages = commonSystemPackages pkgs;
          homebrew = {
            enable = true;
            casks = commonCasks;
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MacBook-Pro-von-Benjamin
      darwinConfigurations."MacBook-Pro-von-Benjamin" = nix-darwin.lib.darwinSystem {
        modules = [
          baseConfiguration
          personalConfiguration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "benni";

              autoMigrate = true;

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = true;
            };
          }
        ];
      };

      darwinConfigurations."MacBook-Pro-BJR" = nix-darwin.lib.darwinSystem {
        modules = [
          baseConfiguration
          workConfiguration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "bjr";

              autoMigrate = true;

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = true;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      personalDarwinPackages = self.darwinConfigurations."MacBook-Pro-von-Benjamin".pkgs;
      workDarwinPackages = self.darwinConfigurations."MacBook-Pro-BJR".pkgs;
    };
}
