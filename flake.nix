{
  description = "Nichts here to see.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS system management (Phase 4)
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, nixpkgs-unstable, home-manager, nix-darwin }: {

    # NixOS hosts
    nixosConfigurations.mbp2015 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/mbp2015
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jasper = import ./users/jasper/nixos.nix;
          };
        }
      ];
    };

    # macOS hosts
    darwinConfigurations.mini = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/mini
        home-manager.darwinModules.home-manager
        {
          # Overlay: pull specific packages from unstable
          nixpkgs.overlays = [
            (final: prev: {
              aerospace = nixpkgs-unstable.legacyPackages.${prev.system}.aerospace;
            })
          ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jasper = import ./users/jasper/darwin.nix;
          };
        }
      ];
    };

  };
}
