# Hyprlock configuration
{ theme }:
{
  "hypr/hyprlock.conf".text = ''
    background {
      monitor =
      path = screenshot
      blur_passes = 3
      blur_size = 8
    }

    # Time
    label {
      monitor =
      text = cmd[update:1000] date +"%H:%M"
      color = rgba(${builtins.substring 1 6 theme.text}ff)
      font_size = 90
      font_family = JetBrainsMono Nerd Font
      position = 0, 200
      halign = center
      valign = center
    }

    # Date
    label {
      monitor =
      text = cmd[update:1000] date +"%A, %B %d"
      color = rgba(${builtins.substring 1 6 theme.subtext0}ff)
      font_size = 20
      font_family = JetBrainsMono Nerd Font
      position = 0, 100
      halign = center
      valign = center
    }

    # Username
    label {
      monitor =
      text = $USER
      color = rgba(${builtins.substring 1 6 theme.subtext1}ff)
      font_size = 16
      font_family = JetBrainsMono Nerd Font
      position = 0, -50
      halign = center
      valign = center
    }

    input-field {
      monitor =
      size = 300, 50
      outline_thickness = 3
      dots_size = 0.33
      dots_spacing = 0.15
      dots_center = true
      outer_color = rgba(${builtins.substring 1 6 theme.border}ff)
      inner_color = rgba(${builtins.substring 1 6 theme.surface0}ff)
      font_color = rgba(${builtins.substring 1 6 theme.text}ff)
      fade_on_empty = false
      placeholder_text = <i>Password...</i>
      hide_input = false
      check_color = rgba(${builtins.substring 1 6 theme.accent}ff)
      fail_color = rgba(${builtins.substring 1 6 theme.error}ff)
      fail_text = <i>$FAIL</i>
      position = 0, -120
      halign = center
      valign = center
    }
  '';
}
