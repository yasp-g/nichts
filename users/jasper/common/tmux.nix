# Tmux — terminal multiplexer with catppuccin theme
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      resurrect
      continuum
      # catppuccin & cpu loaded manually in extraConfig (ordering-sensitive)
    ];

    extraConfig = ''
      # Terminal overrides
      set-option -g terminal-overrides ',xterm-256color:RGB'
      set -g renumber-windows on
      set -g status-position top

      # Key bindings
      unbind %
      bind | split-window -h -c "#{pane_current_path}"
      unbind '"'
      bind _ split-window -v -c "#{pane_current_path}"

      # Pane resizing
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r h resize-pane -L 5
      bind -r l resize-pane -R 5
      bind -r m resize-pane -Z
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Catppuccin — options MUST be set before running catppuccin.tmux
      set -g @catppuccin_flavour 'mocha'
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
      set -g @catppuccin_window_flags "icon"

      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux

      # Load catppuccin status modules (after catppuccin.tmux sets up base formatting)
      source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/status/application.conf
      source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/status/cpu.conf
      source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/status/load.conf
      source ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/status/uptime.conf

      # Status bar
      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left ""
      set -ag status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -agF status-right "#{E:@catppuccin_status_load}"
      set -agF status-right "#{E:@catppuccin_status_uptime}"

      # Resurrect / Continuum
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'
      set -g @continuum-save-interval '15'

      # cpu plugin runs LAST — it does text replacement on status-right/left
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
  };
}
