# Centralized theme definitions
# Change activeTheme to switch between themes, then rebuild
{
  # Available: "catppuccin-mocha", "tokyo-night-storm"
  activeTheme = "catppuccin-mocha";

  themes = {
    catppuccin-mocha = {
      name = "Catppuccin Mocha";
      # Base colors
      base = "#1e1e2e";
      mantle = "#181825";
      crust = "#11111b";
      surface0 = "#313244";
      surface1 = "#45475a";
      surface2 = "#585b70";
      overlay0 = "#6c7086";
      overlay1 = "#7f849c";
      overlay2 = "#9399b2";
      # Text colors
      text = "#cdd6f4";
      subtext0 = "#a6adc8";
      subtext1 = "#bac2de";
      # Accent colors
      lavender = "#b4befe";
      blue = "#89b4fa";
      sapphire = "#74c7ec";
      sky = "#89dceb";
      teal = "#94e2d5";
      green = "#a6e3a1";
      yellow = "#f9e2af";
      peach = "#fab387";
      maroon = "#eba0ac";
      red = "#f38ba8";
      mauve = "#cba6f7";
      pink = "#f5c2e7";
      flamingo = "#f2cdcd";
      rosewater = "#f5e0dc";
      # Semantic mappings
      accent = "#89b4fa";        # blue
      accentAlt = "#cba6f7";     # mauve
      warning = "#f9e2af";       # yellow
      error = "#f38ba8";         # red
      success = "#a6e3a1";       # green
      border = "#45475a";        # surface1
      borderActive = "#89b4fa";  # blue
    };

    tokyo-night-storm = {
      name = "Tokyo Night Storm";
      # Base colors
      base = "#24283b";
      mantle = "#1f2335";
      crust = "#1a1b26";
      surface0 = "#292e42";
      surface1 = "#3b4261";
      surface2 = "#414868";
      overlay0 = "#545c7e";
      overlay1 = "#6b7089";
      overlay2 = "#787c99";
      # Text colors
      text = "#c0caf5";
      subtext0 = "#a9b1d6";
      subtext1 = "#9aa5ce";
      # Accent colors
      lavender = "#b4f9f8";
      blue = "#7aa2f7";
      sapphire = "#2ac3de";
      sky = "#7dcfff";
      teal = "#73daca";
      green = "#9ece6a";
      yellow = "#e0af68";
      peach = "#ff9e64";
      maroon = "#db4b4b";
      red = "#f7768e";
      mauve = "#bb9af7";
      pink = "#ff007c";
      flamingo = "#ff9e64";
      rosewater = "#ffc0cb";
      # Semantic mappings
      accent = "#7aa2f7";        # blue
      accentAlt = "#bb9af7";     # mauve
      warning = "#e0af68";       # yellow
      error = "#f7768e";         # red
      success = "#9ece6a";       # green
      border = "#3b4261";        # surface1
      borderActive = "#7aa2f7";  # blue
    };
  };
}
