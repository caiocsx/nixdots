# Everyday use

## First login

- Select the Hyprland session managed by UWSM in Ly.
- Open Kitty with `SUPER + Return`, or search shortcuts with `SUPER + F1`.

## Apply changes

The checkout is expected at `~/nixdots`. Stage and validate changes there before activating them:

```bash
cd ~/nixdots
git add -A
nck
nrs
```

## Shell aliases

The aliases below are defined in [`zsh.nix`](../modules/home/programs/cli/zsh.nix). `nh` uses the checkout path configured in [`shell.nix`](../modules/home/programs/cli/shell.nix).

`nh` selects the host matching the current machine's hostname, so the system aliases work from any directory. The commands below show `#atlas` as an example; replace it with your host, such as `hyperion`. The suffix can be omitted when the flake has an output matching the current hostname, as described in the [NixOS rebuild documentation](https://wiki.nixos.org/wiki/Nixos-rebuild).

| Alias | Full command / direct equivalent | Purpose |
| --- | --- | --- |
| `nck` | `nix flake check ~/nixdots` | Check the flake |
| `nrb` | `nh os build` / `nixos-rebuild build --flake ~/nixdots#atlas` | Build without activating |
| `nrt` | `nh os test` / `sudo nixos-rebuild test --flake ~/nixdots#atlas` | Activate temporarily; reboot returns to the boot default |
| `nrs` | `nh os switch` / `sudo nixos-rebuild switch --flake ~/nixdots#atlas` | Activate and make the generation the boot default |
| `nrbt` | `nh os boot` / `sudo nixos-rebuild boot --flake ~/nixdots#atlas` | Make the generation the boot default without activating it now |
| `nup` | `nix flake update --flake ~/nixdots` | Update all flake inputs |
| `nupg` | `nix flake update --flake ~/nixdots && nix flake check ~/nixdots && nh os switch` / direct equivalent: `nix flake update --flake ~/nixdots && nix flake check ~/nixdots && sudo nixos-rebuild switch --flake ~/nixdots#atlas` | Update, check, and activate in one command |
| `ncl` | `nh clean all` | Clean old generations and store paths |

See the [NixOS rebuild documentation](https://wiki.nixos.org/wiki/Nixos-rebuild) for details. Home Manager is integrated into NixOS, so a system rebuild also applies the home configuration.

The CI workflow runs `nix flake check`. With the current flake outputs, this validates the host configurations; it does not replace a full system build or a desktop session test.

## Update dependencies

To review a dependency update before activation, update the lock file, inspect its diff, check the flake, and build:

```bash
cd ~/nixdots
nup
git diff -- flake.lock
nck
nrb
```

After reviewing the diff and build, activate with `nrs`. Commit `flake.lock` if you keep the update. To update one input instead of all inputs, run `nix flake update zen-browser` from the checkout and follow the same review steps.

## Wallpapers and screenshots

Add JPG, JPEG, PNG, or GIF files to `~/Pictures/Wallpapers`. The repository does not include wallpaper images.

| Action | Shortcut or command |
| --- | --- |
| Open the wallpaper picker | `SUPER + W` |
| Previous / next wallpaper | `SUPER + Alt + [` / `]` |
| Choose a random wallpaper | `wallpaper-picker --random` |
| Apply a specific image | `wallpaper-picker --set /path/to/image.png` |
| Print the current image path | `wallpaper-picker --current` |

The picker stores the selected wallpaper and lock-screen image under `~/.cache/wallpapers`. GIFs use a still frame for the lock screen.

`SUPER + Print` copies a region, `SUPER + Shift + Print` copies a selected window, and `SUPER + Ctrl + Print` copies a selected monitor. Add `Alt` to open the corresponding capture in Swappy. Saved images go to `~/Pictures/Screenshots`.

For all shortcuts, press `SUPER + F1` or inspect [`binds.nix`](../modules/home/desktop/hyprland/config/binds.nix).

## Recovery

### A rebuild or Home Manager activation fails

Start with the reported error. For Home Manager activation failures, inspect the service, replacing `caiocsx` with your username:

```bash
systemctl status home-manager-caiocsx.service
journalctl -b -u home-manager-caiocsx.service
```

If activation reports that a file already exists, back up and move that specific file before retrying. A successful build alone does not test Home Manager file activation.

### The new generation does not work

If the system still starts, return to the previous generation with:

```bash
sudo nixos-rebuild switch --rollback
```

If it cannot reach a usable session, choose an older generation in GRUB. After booting it, make the running generation the boot default with:

```bash
sudo /run/current-system/bin/switch-to-configuration boot
```

Rollback does not revert repository edits, personal files, or application data. The configured weekly garbage collection deletes generations older than 14 days, and GRUB lists up to 10 configurations. Keep backups and avoid running cleanup while you still need an older generation for recovery.
