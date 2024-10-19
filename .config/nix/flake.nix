{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew}:
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

          # Tools
          pkgs.obsidian
    ];

    commonCasks = [ 
        "google-chrome"
        "firefox"
        "discord"
        "raycast"
        "tableplus"
        "maccy"
        "linearmouse"
        "docker"
    ];

    baseConfiguration = { pkgs, ... }: {
      # Cannot be installed with nix packages
      homebrew = {
        brews = [
          "volta"
        ];
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      # Set system settings.
      system.defaults = {
          loginwindow.GuestEnabled = false;
          dock.autohide = true;
          trackpad.Clicking = false;
          finder.AppleShowAllExtensions = true;
          finder.AppleShowAllFiles = true;
          NSGlobalDomain.KeyRepeat = 2;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      nixpkgs.config.allowUnfree = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };

    personalConfiguration = { pkgs, ... }: {
        environment.systemPackages = commonSystemPackages pkgs;
        homebrew = {
            enable = true;
            casks = commonCasks ++ [ "1password" "discord" ];
            onActivation.cleanup = "zap";
        };
    };

    workConfiguration = { pkgs, ... }: {
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

    # Expose the package set, including overlays, for convenience.
    personalDarwinPackages = self.darwinConfigurations."MacBook-Pro-von-Benjamin".pkgs;
  };
}
