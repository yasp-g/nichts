# mbp2015 cheatsheet

## Hyprland (mod = Alt)
- **Alt + Q**            terminal (ghostty)
- **Alt + R**            app launcher (wofi)
- **Alt + E**            file manager (thunar)
- **Alt + C**            close window
- **Alt + V**            toggle floating
- **Alt + arrows**       move focus
- **Alt + 1..0**         switch workspace
- **Alt + Shift + 1..0** move window to workspace
- **Alt + S**            magic scratchpad
- **Alt + /**            this cheatsheet
- **Ctrl + Super + Q**   lock (hyprlock)

## NixOS rebuild
```bash
nix flake update
sudo nixos-rebuild switch --flake .#mbp2015
nix-collect-garbage -d
```

## Gotchas
- `git add` new files before rebuild (flakes ignore untracked)
- Waybar won't hot-reload: `pkill waybar && hyprctl dispatch exec waybar`
- Unfree/insecure pkgs go in `allowedUnfreePackages` / `allowedInsecurePackages`

## WiFi (NetworkManager)
Easiest: click the WiFi icon in the topbar → opens `nmtui`.

CLI:
```bash
nmcli radio wifi on                     # ensure radio on
nmcli device wifi rescan                # force fresh scan
nmcli device wifi list                  # show scan results
nmcli device wifi connect <SSID> password <PW>
nmcli device wifi connect <SSID> --ask  # prompts for password
nmcli device wifi connect "SSID with spaces" --ask
nmcli connection show                   # saved networks
nmcli connection up <name>              # reconnect saved
nmcli connection delete <name>          # forget
nmcli radio wifi off / on               # toggle radio
nmcli device status                     # all interfaces
ip route                                # verify default gateway
```

Captive portal: after `connect`, open http://neverssl.com in firefox.

## Bluetooth
GUI: click the BT icon in the topbar → blueman-manager.

CLI (`bluetoothctl`):
```
power on
agent on
default-agent
scan on                     # find devices
devices                     # list found (grab MAC)
pair   AA:BB:CC:DD:EE:FF
trust  AA:BB:CC:DD:EE:FF
connect AA:BB:CC:DD:EE:FF
scan off
exit
```

Reconnect a paired device: `bluetoothctl connect <MAC>`
List paired: `bluetoothctl devices Paired`

## Audio (PipeWire)
```bash
wpctl status                          # sinks/sources
wpctl set-default <id>                # switch output
```
Volume/mute keys work natively.
