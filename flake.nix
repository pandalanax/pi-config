{
  description = "Pandalanax's configured Pi coding agent";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, pi }:
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
    in
    {
      packages = forAllSystems (system: {
        default = pi.packages.${system}.coding-agent;
        pi-coding-agent = pi.packages.${system}.coding-agent;
      });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/pi";
        };
      });

      homeModules.default = { ... }: {
        imports = [ pi.homeModules.default ];

        programs.pi.coding-agent = {
          enable = true;
          inherit settings rules;
          extensions = [ ./extensions/context-footer.ts ];
        };
      };

      nixosModules.default = { ... }: {
        imports = [ pi.nixosModules.default ];

        programs.pi.coding-agent = {
          enable = true;
          inherit settings rules;
          extensions = [ ./extensions/context-footer.ts ];
        };
      };
    };
}
