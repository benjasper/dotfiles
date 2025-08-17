{
  description = "My Darwin system flake";

  # ---‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑
  # Binary cache configuration (Cachix)
  # Add as many public or private caches as you like.
  # The public keys come from the cache page on https://app.cachix.org.
  nixConfig = {
    extra-substituters = [
      "https://benjasper.cachix.org" # your own cache
      "https://nix-community.cachix.org" # popular public cache
    ];

    extra-trusted-public-keys = [
      # benjasper.cachix.org public key
      "benjasper.cachix.org-1:vy2BNZSDmHNDJXDaeHaXPlh4oumXSW2Z+6a42WBNzH0="
      # nix‑community public key
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  # ---‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑‑

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
        pkgs.neovide
        pkgs.neofetch
        pkgs.zoxide
        pkgs.starship
        pkgs.uv
        pkgs.fd
        pkgs.ripgrep
        pkgs.fzf
        pkgs.sqlite
        pkgs.sqlc
        pkgs.wget
        pkgs.zed-editor

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
        pkgs.cachix
        pkgs.obsidian
        pkgs.croc
        pkgs.gnupg
        pkgs.gnugrep
        pkgs.ffmpeg_6
      ];

      commonCasks = [
        "google-chrome"
        "firefox"
        "raycast"
        "tableplus"
        "maccy"
        "linearmouse"
        "ghostty"
        "yaak"
        "altair-graphql-client"
        "chatgpt"
        "zen-browser"
      ];

      personalOnlyCasks = [
        "docker-desktop"
        "1password"
        "discord"
      ];

      workOnlyCasks = [
        "orbstack"
      ];

      baseConfiguration =
        {
          pkgs,
          config,
          lib,
          ...
        }:
        {
          # Define primary user for the configuration
          system.primaryUser =
            {
              personal = "benni";
              LQ21HJ29YV = "benjaminjasper";
            }
            .${config.networking.hostName} or "benni";

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
              NSGlobalDomain.InitialKeyRepeat = 10;
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

          # Replace postUserActivation with a custom activation script
          system.activationScripts.extraActivation.text = ''
            echo "Writing current system packages list..."

            # Get the current user from primaryUser
            currentUser="${config.system.primaryUser}"

            # Get the user's home directory
            userHome=$(eval echo ~$currentUser)
            FILEPATH="$userHome/.config/nix"

            # Create directory if it doesn't exist
            sudo -u "$currentUser" mkdir -p "$FILEPATH"

            # Get the package list as a newline-separated string
            packages="${
              builtins.concatStringsSep "\n" (
                pkgs.lib.lists.unique (
                  builtins.sort builtins.lessThan (builtins.map (p: "${p.name}") (commonSystemPackages pkgs))
                )
              )
            }"

            # Write the package list to a file, using sudo to write as the proper user
            echo "$packages" | sudo -u "$currentUser" tee "$FILEPATH/current-system-packages" > /dev/null
          '';
        };

      personalConfiguration =
        { pkgs, ... }:
        {
          networking.hostName = "personal";
          environment.systemPackages = commonSystemPackages pkgs;
          homebrew = {
            enable = true;
            casks = commonCasks ++ personalOnlyCasks;
            onActivation.cleanup = "zap";
          };

          nix.settings.trusted-users = [ "root" "benni" ];

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
          networking.hostName = "LQ21HJ29YV";
          environment.systemPackages = commonSystemPackages pkgs;
          homebrew = {
            enable = true;
            casks = commonCasks ++ workOnlyCasks;
          };

          nix.settings.trusted-users = [ "root" "benjaminjasper" ];
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#personal
      darwinConfigurations."personal" = nix-darwin.lib.darwinSystem {
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
      personalDarwinPackages = self.darwinConfigurations."personal".pkgs;
      workDarwinPackages = self.darwinConfigurations."LQ21HJ29YV".pkgs;
    };
}
