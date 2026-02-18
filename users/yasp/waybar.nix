# Waybar status bar configuration
{ theme }:
{
  enable = true;
  systemd.enable = true;

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "1";
          "2" = "2";
          "3" = "3";
          "4" = "4";
          "5" = "5";
          "6" = "6";
          "7" = "7";
          "8" = "8";
          "9" = "9";
          "10" = "0";
        };
        persistent-workspaces = {
          "*" = 5;
        };
      };

      "hyprland/window" = {
        max-length = 50;
      };

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󰚥 {capacity}%";
        format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      network = {
        format-wifi = "󰤨 {essid}";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰤭 Disconnected";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 Muted";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      tray = {
        spacing = 10;
      };
    };
  };

  style = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 13px;
    }

    window#waybar {
      background-color: rgba(${builtins.substring 1 2 theme.base}${builtins.substring 3 2 theme.base}${builtins.substring 5 2 theme.base}, 0.9);
      color: ${theme.text};
      border-bottom: 2px solid rgba(${builtins.substring 1 2 theme.overlay1}${builtins.substring 3 2 theme.overlay1}${builtins.substring 5 2 theme.overlay1}, 0.3);
    }

    #workspaces button {
      padding: 0 8px;
      color: ${theme.overlay0};
      background: transparent;
      border: none;
      border-radius: 0;
    }

    #workspaces button.active {
      color: ${theme.text};
      background: rgba(${builtins.substring 1 2 theme.overlay1}${builtins.substring 3 2 theme.overlay1}${builtins.substring 5 2 theme.overlay1}, 0.2);
    }

    #workspaces button:hover {
      background: rgba(${builtins.substring 1 2 theme.overlay1}${builtins.substring 3 2 theme.overlay1}${builtins.substring 5 2 theme.overlay1}, 0.1);
    }

    #window {
      padding: 0 10px;
      color: ${theme.subtext0};
    }

    #clock,
    #battery,
    #network,
    #pulseaudio,
    #tray {
      padding: 0 10px;
    }

    #battery.warning {
      color: ${theme.warning};
    }

    #battery.critical {
      color: ${theme.error};
    }

    #network.disconnected {
      color: ${theme.overlay0};
    }

    #pulseaudio.muted {
      color: ${theme.overlay0};
    }
  '';
}
