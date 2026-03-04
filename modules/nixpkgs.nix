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
      description = "Insecure package names/prefixes to allow (prefix-matched)";
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.allowedUnfreePackages;

    # Use prefix matching so version changes don't require config updates
    nixpkgs.config.allowInsecurePredicate = pkg:
      builtins.any (prefix: lib.hasPrefix prefix (lib.getName pkg)) config.allowedInsecurePackages;
  };
}
