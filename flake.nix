{
  description = "Nichts here to see.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS system management (Phase 4)
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }: {

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

    # Standalone Home Manager (Phase 2–3, replaced by darwinConfigurations in Phase 4)
    homeConfigurations.jasper = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      modules = [ ./users/jasper/darwin.nix ];
    };

    # macOS hosts (uncomment in Phase 4)
    # darwinConfigurations.mini = nix-darwin.lib.darwinSystem {
    #   system = "aarch64-darwin";
    #   modules = [
    #     ./hosts/mini
    #     home-manager.darwinModules.home-manager
    #     {
    #       home-manager = {
    #         useGlobalPkgs = true;
    #         useUserPackages = true;
    #         users.jasper = import ./users/jasper/darwin.nix;
    #       };
    #     }
    #   ];
    # };

  };
}
