# Shared Home Manager configuration across all machines
{ config, lib, pkgs, ... }:

{
  imports = [ ./common/tmux.nix ];

  home.packages = with pkgs; [
    # Essentials
    git
    neovim
    fzf              # fuzzy finder
    ripgrep          # fast grep
    tree
    rsync            # file sync
    neofetch         # system info

    # Daily-use tools
    chafa            # image to terminal
    ffmpeg           # media converter
    glow             # cli markdown reader
    gnupg            # encryption
    gtt              # translation tui
    opencode         # ai coding assistant
    tenv             # terraform version manager
    trash-cli        # safe delete
    uv               # python package manager
    yazi             # file manager

    # Dev/specialty tools
    exercism
    luarocks         # lua package manager
    keymapp          # zsa keyboard config

    # GUI apps
    claude-code
    discord
    obsidian
    vscode
    zed-editor

    # Fonts
    nerd-fonts.meslo-lg
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

  # SSH (base config; macOS adds UseKeychain in darwin.nix)
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
    };
  };

  # GitHub CLI
  xdg.configFile."gh" = {
    source = ./common/gh;
    recursive = true;
  };

  # Zed editor — settings only, conversations/prompts/themes are runtime data
  xdg.configFile."zed/settings.json".text = builtins.readFile ./common/zed-settings.json;

  # FZF — fuzzy finder with shell integration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Powerlevel10k instant prompt (must be first)
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
      # Powerlevel10k theme + config
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.config/nix-config/users/jasper/common/p10k.zsh ]] || source ~/.config/nix-config/users/jasper/common/p10k.zsh

      # PATH additions (non-Nix tools)
      export MODULAR_HOME="$HOME/.modular"
      PATH="$HOME/.luarocks/bin:$PATH"
      PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"
      export PATH

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    ''
    ];
  };

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
