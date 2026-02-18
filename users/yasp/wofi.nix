# Wofi launcher styling
{ theme }:
{
  "wofi/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font", monospace;
      font-size: 14px;
    }

    window {
      background-color: ${theme.base};
      border: 2px solid ${theme.accent};
      border-radius: 12px;
    }

    #input {
      margin: 10px;
      padding: 10px;
      border: none;
      border-radius: 8px;
      background-color: ${theme.surface0};
      color: ${theme.text};
    }

    #input:focus {
      border: none;
      outline: none;
    }

    #outer-box {
      margin: 0px;
      padding: 10px;
    }

    #scroll {
      margin: 0px;
      padding: 0px;
    }

    #inner-box {
      margin: 0px;
      padding: 0px;
    }

    #entry {
      margin: 2px;
      padding: 10px;
      border-radius: 8px;
      color: ${theme.text};
    }

    #entry:selected {
      background-color: ${theme.surface1};
      color: ${theme.text};
    }

    #entry:hover {
      background-color: ${theme.surface0};
    }

    #text {
      margin: 0px 5px;
    }

    #img {
      margin: 0px 5px;
    }
  '';
}
