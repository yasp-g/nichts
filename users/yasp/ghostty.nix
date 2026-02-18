# Ghostty terminal configuration
{ theme }:
{
  "ghostty/config".text = ''
    font-family = JetBrainsMono Nerd Font
    font-size = 12

    # Theme: ${theme.name}
    background = ${theme.base}
    foreground = ${theme.text}
    cursor-color = ${theme.text}
    selection-background = ${theme.surface1}
    selection-foreground = ${theme.text}

    # Normal colors
    palette = 0=${theme.surface1}
    palette = 1=${theme.red}
    palette = 2=${theme.green}
    palette = 3=${theme.yellow}
    palette = 4=${theme.blue}
    palette = 5=${theme.mauve}
    palette = 6=${theme.teal}
    palette = 7=${theme.subtext1}

    # Bright colors
    palette = 8=${theme.surface2}
    palette = 9=${theme.red}
    palette = 10=${theme.green}
    palette = 11=${theme.yellow}
    palette = 12=${theme.blue}
    palette = 13=${theme.mauve}
    palette = 14=${theme.teal}
    palette = 15=${theme.text}

    window-padding-x = 10
    window-padding-y = 10
  '';
}
