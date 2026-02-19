# Rename user: yasp → jasper

Both machines are being renamed to use the username `jasper` for consistency.

## Mac Mini (macOS)

1. Create a temporary admin account (System Settings → Users & Groups → Add Account)
2. Log out of `JasperG`, log into the temp admin
3. Rename the account and home folder:
   - System Settings → Users & Groups → right-click `JasperG` → Advanced Options
   - Change "Account name" to `jasper`
   - Change "Home directory" to `/Users/jasper`
   - Rename the home folder: `sudo mv /Users/JasperG /Users/jasper`
4. Log out of temp admin, log into `jasper`
5. Verify everything works, then delete the temp admin account

## MacBook Pro (NixOS)

The nix config already defines `users.users.jasper` (the rebuild will create this user). But the old `yasp` user and its home directory need to be migrated.

**Do this in order — all steps on the MBP:**

### Step 1: Rename the Linux user (before rebuilding)

```bash
# Log in as yasp, then switch to a root shell
sudo -i

# Rename the user account and move the home directory
usermod -l jasper yasp
usermod -d /home/jasper -m jasper

# Rename the primary group
groupmod -n jasper yasp

# Exit root shell
exit
```

You'll be kicked out of your session. Log back in as `jasper`.

### Step 2: Pull the updated nix config and rebuild

```bash
cd ~/.config/nix-config
git pull

# Rebuild — the config already expects users.users.jasper
sudo nixos-rebuild switch --flake .#mbp2015
```

### Step 3: Verify

```bash
whoami          # should print: jasper
echo $HOME      # should print: /home/jasper
ls ~/           # your files should all be here
```

### Step 4: Clean up

If anything references the old username:

```bash
# Check for stale references
grep -r "yasp" ~/.config/ 2>/dev/null
grep -r "/home/yasp" ~/.config/ 2>/dev/null
```

Fix any that matter. Auto-generated files (caches, state) will regenerate on their own.

## After both machines are renamed

- The nix-config repo is already updated — all `.nix` files use `jasper`
- The repo path on the Mac mini will be `/Users/jasper/.config/nix-config`
- The repo path on the MBP stays at `/home/jasper/.config/nix-config` (was `/home/yasp/.config/nix-config`)
- Continue with Phase 1 of the mini transition (`docs/mini-transition/ROADMAP.md`)
