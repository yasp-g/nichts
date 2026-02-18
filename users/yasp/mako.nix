# Mako notification daemon configuration
{ theme }:
{
  "mako/config".text = ''
    font=JetBrainsMono Nerd Font 11
    background-color=${theme.base}
    text-color=${theme.text}
    border-color=${theme.accent}
    border-size=2
    border-radius=8
    padding=15
    margin=10
    width=350
    height=150
    default-timeout=5000
    anchor=top-right

    [urgency=low]
    border-color=${theme.overlay0}

    [urgency=high]
    border-color=${theme.error}
    default-timeout=0
  '';
}
