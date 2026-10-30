# Everyday use

## First login

At Ly, select the Hyprland session managed by UWSM. Once logged in, press `SUPER + Alt + K` to search the configured keybinds.

On the first launch after login, some applications such as VS Code and Zen Browser may not pick up their configured settings right away. Close and reopen the application to apply them.

## Apply changes

The checkout is expected at `~/nixdots`. Stage and validate changes there before activating them:

```bash
cd ~/nixdots
git add -A
nck
nrs
```

## Shell aliases

The aliases below are defined in [`zsh.nix`](../modules/home/programs/cli/zsh.nix). `nh` uses the checkout path configured in [`nh.nix`](../modules/home/programs/cli/nh.nix).

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

## Development environments

Use the [development templates](development.md) to initialize a project's development environment. Templates are copied into each project, which owns its environment and lock file independently of nixdots. The guide covers discovering templates, initialization, automatic activation, customization, and sharing the project.

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

`SUPER + Print` captures a region, `SUPER + Shift + Print` captures a selected window, and `SUPER + Ctrl + Print` captures a selected monitor. `SUPER + Shift + F12` captures a region after a 5-second delay. Each capture is saved to `~/Pictures/Screenshots` and copied to the clipboard. The same behavior is available with `screenshot --region`, `screenshot --window`, and `screenshot --output`; add `--delay 5` for a five-second delay.

## Workspaces and layouts

`SUPER + Tab` switches to the next existing workspace, and `SUPER + Shift + Tab` switches to the previous one. `SUPER + Alt + L` cycles the active workspace through `scrolling`, `dwindle`, `master`, and `monocle`. Use `SUPER + H/J/K/L` to focus left/down/up/right; add `Shift` to move the focused window in that direction. Browser windows with classes for Brave, Firefox, or Zen are assigned to workspace 1; VSCodium, VS Code, and Zed are assigned to workspace 2. See [`rules.nix`](../modules/home/desktop/hyprland/config/rules.nix) for the window rules and [`binds.nix`](../modules/home/desktop/hyprland/config/binds.nix) for the complete shortcut list.

## Backups

NixOS schedules a daily Restic backup of `~/Documents`, `~/Pictures`, `~/Projects`, and `~/nixdots`. Other home-directory contents—including `~/Downloads`, `~/Desktop`, and hidden application configuration—are not included. `node_modules`, `target`, and `.direnv` directories under `~/Projects`, plus `~/nixdots/result`, are excluded.

The retention policy keeps up to 7 daily, 4 weekly, and 3 monthly snapshots; overlapping periods can refer to the same snapshot. The repository is stored at `/var/lib/restic/caiocsx` on the same disk as the backed-up files. It can help recover accidentally changed or deleted files, but it does not protect against disk failure. The repository is encrypted, so keep the passphrase in a password manager; without it, the data cannot be decrypted.

Before the first backup, create the password file outside the Nix store and set a strong passphrase:

```bash
sudo install -d -m 700 /etc/restic
sudo install -m 600 /dev/null /etc/restic/caiocsx-password
SUDO_EDITOR=nvim sudoedit /etc/restic/caiocsx-password
```

Enter the passphrase in Neovim and save with `:wq`. The `SUDO_EDITOR` override avoids opening the GUI editor configured as `EDITOR`.

After activating the configuration with `nrs`, the `restic` command is available in your shell and the timer runs daily. Start the first backup immediately and inspect its status with:

```bash
sudo systemctl start restic-backups-home.service
sudo systemctl status restic-backups-home.service
sudo restic -r /var/lib/restic/caiocsx --password-file /etc/restic/caiocsx-password snapshots
```

Check the repository periodically, for example every few months:

```bash
sudo restic -r /var/lib/restic/caiocsx --password-file /etc/restic/caiocsx-password check
```

This checks the repository structure and metadata. To also read and verify all backed-up data, use `check --read-data`; this reads the entire repository and can take a while. See the [Restic integrity check documentation](https://restic.readthedocs.io/en/stable/045_working_with_repos.html#checking-a-repo-s-integrity-and-consistency).

To recover a deleted file, first list the snapshots and find the file's path in a snapshot. For example:

```bash
sudo restic -r /var/lib/restic/caiocsx --password-file /etc/restic/caiocsx-password snapshots
sudo restic -r /var/lib/restic/caiocsx --password-file /etc/restic/caiocsx-password find 'file-name'
```

Restore just that file into a temporary directory, replacing the example path with the full path shown by `find`:

```bash
sudo restic -r /var/lib/restic/caiocsx --password-file /etc/restic/caiocsx-password restore latest --target /tmp/restic-restore --include /home/caiocsx/Documents/path/to/file
```

The restored file will be under `/tmp/restic-restore/home/caiocsx/...`. Check it there, then copy it back to its original location. Restic's `--include` option restricts the restore to the selected path; see the [Restic restore documentation](https://restic.readthedocs.io/en/stable/050_restore.html) for details. The passphrase is required to access the repository; keep it in a password manager.

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
