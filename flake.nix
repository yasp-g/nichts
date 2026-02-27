{
  description = "Nichts here to see.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # macOS system management (Phase 4)
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, nix-darwin }: {

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
      pkgs = import nixpkgs-darwin {
        system = "aarch64-darwin";
        config.allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs-darwin.lib.getName pkg) [
            "keymapp"
          ];
      };
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
