{
  description = "Pandalanax's configured Pi coding agent";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pi,
    }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      settings = builtins.fromJSON (builtins.readFile ./settings.json);
      rules = builtins.readFile ./APPEND_SYSTEM.md;
      bundledStatusline =
        pkgs:
        pkgs.runCommand "pi-statusline.js"
          {
            nativeBuildInputs = [ pkgs.esbuild ];
            src = ./extensions/statusline;
          }
          ''
            esbuild "$src/src/statusline.ts" \
              --bundle \
              --format=esm \
              --packages=external \
              --platform=node \
              --outfile="$out"
          '';
      agentConfig = pkgs: {
        inherit settings rules;
        extensions = [ (bundledStatusline pkgs) ];
      };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          configured = pi.lib.mkCodingAgent {
            inherit pkgs;
            modules = [ { pi.coding-agent = agentConfig pkgs; } ];
          };
        in
        {
          default = configured.package;
          pi-coding-agent = configured.package;
          statusline-extension = bundledStatusline pkgs;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/pi";
        };
      });

      homeModules.default = { pkgs, ... }: {
        imports = [ pi.homeModules.default ];
        programs.pi.coding-agent = agentConfig pkgs // {
          enable = true;
        };
      };

      nixosModules.default = { pkgs, ... }: {
        imports = [ pi.nixosModules.default ];
        programs.pi.coding-agent = agentConfig pkgs // {
          enable = true;
        };
      };
    };
}
