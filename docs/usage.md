# Everyday use

[← README](../README.md) · [Installation](installation.md) · [Customization](customization.md)

## Apply changes

The checkout is expected at `~/nixdots`. Select your host explicitly when using `nixos-rebuild`:

```bash
cd ~/nixdots
target_host=atlas

git diff
git add flake.nix hosts modules
nix flake check --no-build
sudo nixos-rebuild build --flake ".#$target_host"
sudo nixos-rebuild switch --flake ".#$target_host"
```

Home Manager is part of the NixOS module graph, so the rebuild also updates your home configuration. There is no standalone `homeConfigurations` output to activate separately.

`build` compiles without activation; `switch` activates and makes the generation the boot default. Use `test` for temporary activation, or `boot` to select the next boot configuration without activating it now. These modes are described in the [nixos-rebuild documentation](https://wiki.nixos.org/wiki/Nixos-rebuild).

The CI workflow runs `nix flake check`. With the current flake outputs, this validates the host configurations; it does not replace a full system build or a desktop session test.

## Shell aliases

These are defined in [`zsh.nix`](../modules/home/programs/cli/zsh.nix). `nh` uses the checkout path from [`shell.nix`](../modules/home/programs/cli/shell.nix) and the machine's hostname to select its configuration.

| Alias | Command | Purpose |
| --- | --- | --- |
| `nck` | `nix flake check ~/nixdots` | Validate the flake |
| `nrb` | `nh os build` | Build the system |
| `nrt` | `nh os test` | Activate temporarily |
| `nrs` | `nh os switch` | Build and activate |
| `nrboot` | `nh os boot` | Prepare the next boot |
| `nup` | `nix flake update --flake ~/nixdots` | Update all inputs |
| `nupg` | Update inputs, check the flake, then `nh os switch` | Update and activate together |
| `ncl` | `nh clean all` | Clean old generations and store paths |

If you store the repository elsewhere, update both the `nh` path and the aliases. Keep your host output name aligned with `networking.hostName`.

## Update dependencies

For a reviewable update, separate changing the lock file from activating the system:

```bash
cd ~/nixdots
nix flake update
git diff -- flake.lock
nix flake check --no-build
nh os build
nh os switch
```

To update one input, use its name, for example `nix flake update zen-browser`. Commit `flake.lock` after validating the update. Keeping configuration edits and dependency updates in separate commits makes regressions easier to investigate.

## Wallpapers and screenshots

Add JPG, JPEG, PNG, or GIF files to `~/Pictures/Wallpapers`. The repository does not include wallpaper images.

| Action | Shortcut or command |
| --- | --- |
| Open the wallpaper picker | `SUPER + W` |
| Previous / next wallpaper | `SUPER + Alt + [` / `]` |
| Choose a random wallpaper | `wallpaper-picker --random` |
| Apply a specific image | `wallpaper-picker --set /path/to/image.png` |
| Print the current image path | `wallpaper-picker --current` |

The picker maintains the selected wallpaper and lock-screen image under `~/.cache/wallpapers`. GIFs use a still frame for the lock screen.

`SUPER + Print` copies a region, `SUPER + Shift + Print` copies a selected window, and `SUPER + Ctrl + Print` copies a selected monitor. Add `Alt` to open the corresponding capture in Swappy. Saved images go to `~/Pictures/Screenshots`.

For all shortcuts, open `SUPER + F1` or inspect [`binds.nix`](../modules/home/desktop/hyprland/config/binds.nix).

## Recovery

### A rebuild or Home Manager activation fails

Start with the reported error. For user configuration failures, inspect the integrated activation service, substituting your username:

```bash
systemctl status home-manager-caiocsx.service
journalctl -b -u home-manager-caiocsx.service
```

If it reports an existing file in the way, back up and move that specific file before retrying. A successful build alone does not test home-file activation.

### The new generation does not work

For a previous system generation that is still available:

```bash
sudo nixos-rebuild switch --rollback
```

If the machine cannot reach a usable session, select an older generation in the boot menu. After booting it, make that running generation the boot default with:

```bash
sudo /run/current-system/bin/switch-to-configuration boot
```

Rollback does not revert your working tree, personal files, or application data. Restore the relevant configuration edits before rebuilding. See the [NixOS rollback instructions](https://nixos.org/manual/nixos/stable/#sec-rollback) for generation recovery.

The configured weekly garbage collection deletes generations older than 14 days, and GRUB lists up to 10 configurations. Keep backups and avoid running cleanup while you still need an older generation for recovery.
