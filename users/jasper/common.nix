# Shared Home Manager configuration across all machines
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Populated during Phase 2 migration
  ];

  programs.home-manager.enable = true;

  # Neovim — full Lua config sourced from repo
  home.sessionVariables.EDITOR = "nvim";
  xdg.configFile."nvim" = {
    source = ./common/nvim;
    recursive = true;
  };

  # Yazi — config files only, plugins managed by yazi's package manager
  xdg.configFile."yazi" = {
    source = ./common/yazi;
    recursive = true;
  };

  # SSH
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      extraOptions.UseKeychain = "yes";
      identityFile = "~/.ssh/id_rsa";
    };
  };

  # GitHub CLI
  xdg.configFile."gh" = {
    source = ./common/gh;
    recursive = true;
  };

  # Zed editor — settings only, conversations/prompts/themes are runtime data
  xdg.configFile."zed/settings.json".text = builtins.readFile ./common/zed-settings.json;

  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "yasp-g";
      user.email = "jasper@yasp.studio";
      init.defaultBranch = "main";
      core.autocrlf = "input";
    };
  };
}
