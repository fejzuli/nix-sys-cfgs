{
  description = "Nix system configurations";

  inputs = {
    nixpkgs-unstable.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.zst";
    nixpkgs-nixos.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    nixpkgs-darwin.url = "https://channels.nixos.org/nixpkgs-26.05-darwin/nixexprs.tar.zst";
    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    index-db = {
      url = "github:/nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-nixos,
      nixpkgs-darwin,
      darwin,
      index-db,
    }:
    let
      lib = nixpkgs-unstable.lib;
      perSystem = lib.genAttrs [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      defaults =
        { config, ... }:
        let
          system = config.nixpkgs.hostPlatform.system;
        in
        {
          nix = {
            channel.enable = false;
            settings = {
              experimental-features = "nix-command flakes";
              sandbox = true;
            };
          };
          nixpkgs.overlays = [ self.overlays.default ];
          system.configurationRevision = self.rev or self.dirtyRev or null;
        };

      mkDarwin = modules: darwin.lib.darwinSystem { inherit modules; };
    in
    {
      darwinConfigurations.franky = mkDarwin [
        defaults
        index-db.darwinModules.nix-index
        { programs.nix-index-database.comma.enable = true; }
        ./franky.nix
      ];

      overlays.default =
        final: _:
        let
          system = final.stdenv.hostPlatform.system;
        in
        {
          custom = self.packages.${system};
          unstable = nixpkgs-unstable.legacyPackages.${system};
        };

      packages = perSystem (
        system: import ./packages { pkgs = nixpkgs-unstable.legacyPackages.${system}; }
      );
    };
}
