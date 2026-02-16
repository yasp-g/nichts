# Nixpkgs configuration with mergeable unfree/insecure package lists
{ config, lib, pkgs, ... }:

{
  options = {
    allowedUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Unfree package names to allow";
    };

    allowedInsecurePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Insecure package names to allow";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.allowedUnfreePackages;

    nixpkgs.config.permittedInsecurePackages = config.allowedInsecurePackages;
  };
}
