{
  description = "z-nvim: Declarative Neovim configuration for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixVim for declarative Neovim configuration
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      ...
    }:
    let
      # Semantic versioning
      version = "1.0.0";

      # Version components for programmatic access
      versionInfo = {
        major = 1;
        minor = 0;
        patch = 0;
        # LazyVim version this config targets
        lazyvimVersion = "15.*";
        # Pre-release tag (null for stable releases)
        prerelease = null;
      };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Flake metadata
      inherit version;
      inherit versionInfo;

      # Library functions for version checking
      lib = {
        # Check if a version string satisfies minimum requirements
        # Usage: z-nvim.lib.versionAtLeast "1.0.0"
        versionAtLeast =
          minVersion:
          let
            parse =
              v:
              let
                parts = builtins.filter builtins.isString (builtins.split "\\." v);
              in
              map (s: if s == "" then 0 else builtins.fromJSON s) parts;
            current = parse version;
            minimum = parse minVersion;
            compare =
              a: b:
              if a == [ ] && b == [ ] then
                true
              else if a == [ ] then
                true
              else if b == [ ] then
                builtins.head a >= 0
              else if builtins.head a > builtins.head b then
                true
              else if builtins.head a < builtins.head b then
                false
              else
                compare (builtins.tail a) (builtins.tail b);
          in
          compare current minimum;

        # Get full version string with optional prerelease
        fullVersion =
          if versionInfo.prerelease != null then "${version}-${versionInfo.prerelease}" else version;
      };

      # Home Manager modules
      homeManagerModules = {
        # LazyVim configuration (inline Lua, works without NixVim)
        lazyvim = import ./modules/lazyvim;

        # NixVim configuration (requires NixVim input)
        nixvim = import ./modules/nixvim;

        # Default exports both
        default = {
          imports = [
            ./modules/lazyvim
          ];
        };
      };

      # For backward compatibility
      homeManagerModule = self.homeManagerModules.default;

      # Packages for testing
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Build a standalone test configuration
          testConfig = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              self.homeManagerModules.lazyvim
              {
                home.username = "test";
                home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/test" else "/home/test";
                home.stateVersion = "24.05";
                programs.home-manager.enable = true;
              }
            ];
          };

          # Extract just the nvim config files
          nvimConfigDir = pkgs.runCommand "z-nvim-config" { } ''
            mkdir -p $out
            cp -rL ${testConfig.activationPackage}/home-files/.config/nvim/* $out/
          '';

          # Script to run nvim with the test config
          testRunner = pkgs.writeShellScriptBin "z-nvim-test" ''
            set -euo pipefail

            TEST_DIR="''${ZNVIM_TEST_DIR:-/tmp/z-nvim-test-$$}"
            KEEP_DIR="''${ZNVIM_KEEP:-false}"

            cleanup() {
              if [[ "$KEEP_DIR" != "true" ]] && [[ -d "$TEST_DIR" ]]; then
                chmod -R u+w "$TEST_DIR" 2>/dev/null || true
                rm -rf "$TEST_DIR"
              fi
            }
            trap cleanup EXIT

            mkdir -p "$TEST_DIR"/{config/nvim,data,state,cache}
            cp -rL ${nvimConfigDir}/* "$TEST_DIR/config/nvim/"
            chmod -R u+w "$TEST_DIR/config/nvim"

            export XDG_CONFIG_HOME="$TEST_DIR/config"
            export XDG_DATA_HOME="$TEST_DIR/data"
            export XDG_STATE_HOME="$TEST_DIR/state"
            export XDG_CACHE_HOME="$TEST_DIR/cache"

            if [[ "''${1:-}" == "--check" ]]; then
              echo "Running headless check..."
              if ${pkgs.neovim}/bin/nvim --headless -c 'qall' 2>&1; then
                echo "✓ Config loads successfully"
                exit 0
              else
                echo "✗ Config has errors"
                exit 1
              fi
            else
              echo "Starting nvim with z-nvim config..."
              echo "Test dir: $TEST_DIR"
              echo "(Set ZNVIM_KEEP=true to preserve test dir)"
              echo ""
              exec ${pkgs.neovim}/bin/nvim "$@"
            fi
          '';
        in
        {
          # The extracted nvim config directory
          config = nvimConfigDir;

          # Test runner script
          test = testRunner;

          default = testRunner;
        }
      );

      # Apps for easy running
      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.test}/bin/z-nvim-test";
        };
        test = {
          type = "app";
          program = "${self.packages.${system}.test}/bin/z-nvim-test";
        };
      });
    };
}
