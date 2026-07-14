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
      modules-right = [ "custom/help" "pulseaudio" "bluetooth" "network" "battery" "tray" ];

      "custom/help" = {
        format = "󰋖";
        tooltip = true;
        tooltip-format = "Alt + / — open cheatsheet";
        on-click = "hyprctl dispatch togglespecialworkspace cheatsheet";
      };

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
        on-click = "ghostty -e nmtui";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 Muted";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      bluetooth = {
        format = "󰂯";
        format-connected = "󰂱 {device_alias}";
        format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
        format-off = "󰂲";
        tooltip-format = "{controller_alias}\n{num_connections} connected";
        tooltip-format-connected = "{controller_alias}\n{num_connections} connected\n\n{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_battery_percentage}%";
        on-click = "blueman-manager";
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
      background-color: alpha(${theme.base}, 0.9);
      color: ${theme.text};
      border-bottom: 2px solid alpha(${theme.overlay1}, 0.3);
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
      background: alpha(${theme.overlay1}, 0.2);
    }

    #workspaces button:hover {
      background: alpha(${theme.overlay1}, 0.1);
    }

    #window {
      padding: 0 10px;
      color: ${theme.subtext0};
    }

    #clock,
    #battery,
    #bluetooth,
    #custom-help,
    #network,
    #pulseaudio,
    #tray {
      padding: 0 10px;
    }

    #bluetooth.off {
      color: ${theme.overlay0};
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
