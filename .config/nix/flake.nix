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
        pkgs.atlas
        pkgs.bat
        pkgs.buf # for buf connect
        pkgs.btop
        pkgs.bruno
        pkgs.git
        pkgs.delta
        pkgs.git-lfs
        pkgs.grpcurl # for buf
        pkgs.go-protobuf # for buf
        pkgs.protoc-gen-connect-go # for buf
        pkgs.protoc-gen-doc
        pkgs.lazygit
        pkgs.neovim
        pkgs.neofetch
        pkgs.zoxide
        pkgs.starship
        pkgs.fd
        pkgs.ripgrep
        pkgs.fzf
        pkgs.sqlite
        pkgs.sqlc
        pkgs.wget

        # Languages
        pkgs.go
        pkgs.go-task
        (pkgs.php83.buildEnv {
          extensions = (
            { enabled, all }:
            enabled
            ++ (with all; [
              grpc
              apcu
              memcached
              imagick
            ])
          );
        })
        pkgs.php83Packages.composer
        pkgs.rustup
        pkgs.lua

        # Language Servers and Language Tools
        pkgs.nodePackages."@astrojs/language-server"
        pkgs.biome
        pkgs.clang-tools
        pkgs.delve
        pkgs.gitlab-ci-ls
        pkgs.gopls
        pkgs.go-tools
        pkgs.gotestsum
        pkgs.intelephense
        pkgs.lua-language-server
        pkgs.nixfmt-rfc-style
        pkgs.nil
        pkgs.prettierd
        pkgs.protols
        pkgs.stylua
        pkgs.sql-formatter
        pkgs.tailwindcss-language-server
        pkgs.taplo
        pkgs.templ
        pkgs.vscode-langservers-extracted # Contains HTML, CSS, ESLint and JSON
        pkgs.vtsls
        pkgs.yaml-language-server

        # Tools
        pkgs.obsidian
        pkgs.croc
        pkgs.gnupg
        pkgs.gnugrep
      ];

      commonCasks = [
        "google-chrome"
        "firefox"
        "raycast"
        "tableplus"
        "maccy"
        "linearmouse"
        "docker"
        "ghostty"
        "yaak"
        "altair-graphql-client"
      ];

      baseConfiguration =
        { pkgs, config, ... }:
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
            nerd-fonts.symbols-only
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

          nix.package = pkgs.nix;

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

          # Write the current system packages to the nix flake repo
          system.activationScripts.postUserActivation = {
            text = ''
              FILEPATH=$HOME/.config/nix
              echo "copying current system packages to $FILEPATH/current-system-packages..."

              # Get the package list as a newline-separated string
              packages="${
                builtins.concatStringsSep "\n" (
                  pkgs.lib.lists.unique (
                    builtins.sort builtins.lessThan (builtins.map (p: "${p.name}") (commonSystemPackages pkgs))
                  )
                )
              }"

              # Write the package list to a file
              echo "$packages" > "$FILEPATH/current-system-packages"
            '';
          };
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

          system.defaults = {
            dock.persistent-apps = [
              "/Applications/Safari.app"
              "/Applications/Google Chrome.app"
              "/System/Applications/Mail.app"
              "/System/Applications/Calendar.app"
              "/System/Applications/Music.app"
              "/Applications/Ghostty.app"
            ];
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

      darwinConfigurations."LQ21HJ29YV" = nix-darwin.lib.darwinSystem {
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
              user = "benjaminjasper";

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
      workDarwinPackages = self.darwinConfigurations."LQ21HJ29YV".pkgs;
    };
}
