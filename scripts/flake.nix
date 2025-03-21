{
  description = "Garden configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
    }:
    let
      configuration =
        {
          pkgs,
          config,
          ...
        }:
        {
          security.pam.services.sudo_local.touchIdAuth = true;
          users.users.daisy.home = "/Users/daisy";
          home-manager.backupFileExtension = "backup";


          environment.systemPackages = [
            # App aliases
            pkgs.mkalias

            # Core utilities
            pkgs.openssh 
            pkgs.nmap
            pkgs.curl
            pkgs.wget

            # Terminal
            pkgs.nixd
            pkgs.nixfmt-rfc-style
          ];

          homebrew = {
            # Will remove all the packages that are not in the configuration
            onActivation.cleanup = "zap";
            enable = true;
            onActivation.autoUpdate = true;
            onActivation.upgrade = false;
            onActivation.extraFlags = [ "--verbose" ];

            # Taps
            taps = [
              "koekeishiya/formulae"
              "osrf/simulation"
            ];

            # Non-cask apps
            brews = [
              # Core utilities
              "p7zip"
              "pkg-config"
              "graphviz"
              "mailsy"
              "micro"

              # Terminal
              "neofetch"
              "lsd"

              # Dockers
              "lazydocker"
              "postgresql@14"
              "lazygit"

              # Virtualization
              "qemu"

              # Games
              "cmatrix"

              # Engineering
              "matlab2tikz"

              # ROS
              "socat"
              "python@3.9"
              "gazebo11"

              # Tiling managers
              "koekeishiya/formulae/yabai"
              "skhd"
            ];

            # Cask apps
            casks = [
              # Docker
              "docker"
              "utm" #VM WINDOWS
              "crystalfetch" #Recup images windows
              "whisky"
              "arduino-ide"
            

              # Virtualization
              "virtualbox"
              "raspberry-pi-imager"
              "crystalfetch"
              "balenaetcher"
              "virtualbuddy"
              "xquartz"

              # ObjectiveSee & Safety
              "oversight"
              "lulu"
              "knockknock"
              "blockblock"
              "reikey"
              "bitwarden"
              "surfshark"

              # Browsers
              "arc"
              "zen-browser"
              "tor-browser"

              # Dev apps
              "visual-studio-code"
              "devtoys"
              "mactex"
              "warp"
              "applite"
              

              # Productivity
              "notion"
              "raycast"
              "maccy"
              "cheatsheet"
              "libreoffice"

              # 3D & Design
              "autodesk-fusion"
              "orcaslicer"
              "lycheeslicer"
              "kicad"
              "drawio"

              # Media
              "iina"
              "inkscape"
              "flameshot"
              "adobe-acrobat-reader"
              "obs"

              # Communication
              "thunderbird@esr"
              "microsoft-outlook"
              "signal"
              "discord"

              # Utilities
              "onyx"
              "the-unarchiver"
              "stats"
              "keyboardcleantool"
              "lunar"
              "parsec"
              "jdownloader"
              "lm-studio"

              # Games & Emulators
              "modrinth"
            ];

            # Mac App Store apps
            masApps = { };
          };

          # MacOS default settings
          # Documentation found at: https://mynixos.com/nix-darwin/options/system.defaults
          system = {
            stateVersion = 5;
            configurationRevision = self.rev or self.dirtyRev or null;
            startup.chime = false;
            activationScripts = {
              # Set up the alias for applications to be indexed by the system.
              applications = {
                text = ''
                  echo "setting up /Applications..." >&2
                  rm -rf /Applications/Nix\ Apps
                  mkdir -p /Applications/Nix\ Apps
                  find ${
                    pkgs.buildEnv {
                      name = "system-applications";
                      paths = config.environment.systemPackages;
                      pathsToLink = "/Applications";
                    }
                  }/Applications -maxdepth 1 -type l -exec readlink '{}' + |
                  while read -r src; do
                    app_name=$(basename "$src")
                    echo "copying $src" >&2
                    ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
                  done
                '';
              };
            };
            defaults = {
              ".GlobalPreferences" = {
                "com.apple.mouse.scaling" = 3.0;
                "com.apple.sound.beep.sound" = "/System/Library/Sounds/Blow.aiff";
              };
              dock = {
                autohide = true;
                autohide-time-modifier = 1.0;
                autohide-delay = 0.0;
                enable-spring-load-actions-on-all-items = true;
                expose-group-apps = false;
                largesize = 90;
                launchanim = true;
                magnification = true;
                mineffect = "scale";
                minimize-to-application = true;
                mru-spaces = false;
                orientation = "bottom";
                persistent-apps = [ ];
                show-recents = false;
                showhidden = true;
                show-process-indicators = true;
                static-only = true;
                tilesize = 70;
                # Hot corners
                # Possible values:
                #  1: No action
                #  2: Mission Control
                #  3: Show application windows
                #  4: Desktop
                #  5: Start screen saver
                #  6: Disable screen saver
                #  7: Dashboard
                # 10: Put display to sleep
                # 11: Launchpad
                # 12: Notification Center
                # 13: Lock Screen
                # 14: Quick Note
                wvous-tl-corner = 1;
                wvous-tr-corner = 5;
                wvous-bl-corner = 4;
                wvous-br-corner = 14;
              };
              finder = {
                _FXShowPosixPathInTitle = true;
                _FXSortFoldersFirst = true;
                AppleShowAllExtensions = true;
                AppleShowAllFiles = false;
                CreateDesktop = true;
                FXDefaultSearchScope = "SCcf";
                FXEnableExtensionChangeWarning = true;
                FXPreferredViewStyle = "clmv";
                QuitMenuItem = false;
                ShowPathbar = true;
                ShowStatusBar = true;
              };
              LaunchServices = {
                LSQuarantine = false;
              };
              loginwindow = {
                autoLoginUser = null;
                DisableConsoleAccess = true;
                GuestEnabled = false;
                LoginwindowText = "";
                PowerOffDisabledWhileLoggedIn = false;
                RestartDisabled = false;
                RestartDisabledWhileLoggedIn = false;
                SHOWFULLNAME = false;
                ShutDownDisabled = false;
                ShutDownDisabledWhileLoggedIn = false;
                SleepDisabled = false;
              };
              NSGlobalDomain = {
                "com.apple.mouse.tapBehavior" = 1;
                "com.apple.sound.beep.feedback" = null;
                "com.apple.sound.beep.volume" = 0.7788008;
                "com.apple.swipescrolldirection" = true;
                "com.apple.trackpad.forceClick" = false;
                "com.apple.trackpad.scaling" = 1.0;
                _HIHideMenuBar = true;
                AppleEnableSwipeNavigateWithScrolls = true;
                AppleICUForce24HourTime = true;
                AppleInterfaceStyleSwitchesAutomatically = true;
                AppleScrollerPagingBehavior = true;
                AppleShowScrollBars = "Always";
                KeyRepeat = 1;
                InitialKeyRepeat = 10;
                NSAutomaticWindowAnimationsEnabled = true;
                NSDocumentSaveNewDocumentsToCloud = false;
                NSScrollAnimationEnabled = true;
                NSTableViewDefaultSizeMode = 1;
                NSWindowShouldDragOnGesture = true;
                PMPrintingExpandedStateForPrint = true;
              };
              screencapture = {
                disable-shadow = true;
                location = "~/Desktop";
                show-thumbnail = true;
                type = "png";
              };
              screensaver = {
                askForPassword = true;
                askForPasswordDelay = null;
              };
              SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
              trackpad = {
                ActuationStrength = 1;
                Clicking = true;
                Dragging = false;
                TrackpadRightClick = true;
              };
            };
          };

          nixpkgs = {
            hostPlatform = "aarch64-darwin";
            config.allowUnfree = true;
          };

          nix = {
            package = pkgs.nix;
            gc.automatic = true;
            optimise.automatic = true;
            nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
            settings = {
              experimental-features = [
                "nix-command"
                "flakes"
              ];
            };
            extraOptions = ''
              extra-platforms = x86_64-darwin aarch64-darwin
            '';
          };

          programs.zsh = {
            enable = true;
            enableCompletion = true;
          };
        };
    in
    {
      darwinConfigurations."garden" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "daisy";
            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.daisy = import ./home.nix;
          }
        ];
      };
      darwinPackages = self.darwinConfigurations."garden".pkgs;
    };
}
