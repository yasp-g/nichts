**Topic:** Pitfalls, Friction Points, and Survival Tips.
## Critical Friction Points
• **The "Unadded File" Ghost:** In a Flake, if a file isn't tracked by Git (git add), Nix literally cannot see it. This is a security/purity feature, not a bug.
• **The Storage Hog:** Nix keeps every previous version of your system to allow for instant rollbacks.
• **Action:** Set up Garbage Collection (GC) to run weekly.
• **The FHS Binary Trap:** Standard Linux binaries (downloaded from the web) will fail on NixOS because they expect /lib or /usr/bin.
• **Action:** Use nix-ld or steam-run to wrap them, or find the official Nix recipe.
• **The "Unfree" Wall:** Since you are on Apple hardware, you must explicitly enable allowUnfree = true to get the Wi-Fi drivers working.
## Deployment Commands
• **NixOS (MacBook/Server):** sudo nixos-rebuild switch --flake .#hostname
• **macOS (Mac Mini):** darwin-rebuild switch --flake .#macmini
• **Garbage Collection:** nix-collect-garbage -d