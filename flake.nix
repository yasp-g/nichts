{
  description = "Nichts here to see.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS system management (Phase 6)
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
            users.yasp = import ./users/yasp/home.nix;
          };
        }
      ];
    };

    # macOS hosts (uncomment when ready)
    # darwinConfigurations.mini = nix-darwin.lib.darwinSystem {
    #   system = "aarch64-darwin";
    #   modules = [
    #     ./hosts/mini
    #     home-manager.darwinModules.home-manager
    #     {
    #       home-manager = {
    #         useGlobalPkgs = true;
    #         useUserPackages = true;
    #         users.yasp = import ./users/yasp/home.nix;
    #       };
    #     }
    #   ];
    # };

  };
}
