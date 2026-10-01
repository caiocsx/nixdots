# Installation

[← README](../README.md) · [Customization](customization.md) · [Everyday use](usage.md)

- [Before you start](#before-you-start)
- [Clean install — recommended](#clean-install-recommended)
- [Existing NixOS installation](#existing-nixos-installation)
- [First login](#first-login)

## Before you start

This setup targets an `x86_64-linux` machine with UEFI boot and internet access. The supplied hosts use GRUB, Btrfs, and either NVIDIA or AMD graphics. Other storage layouts can work once the hardware and boot configuration match them.

Choose `atlas` or `hyperion` as a starting point, or [add a host](customization.md#add-a-host). The examples use `atlas` and `caiocsx`; change the shell variables and the corresponding Nix declarations together.

Read [Adapt the configuration](customization.md#adapt-the-configuration) before building. In particular, replace the hardware file, review GPU and monitor settings, and set your username and Git identity. These settings are not inferred from the machine running the installer.

Keep the committed `flake.lock` for the initial installation. Update dependencies separately after the system is working.

## Clean install (recommended)

### 1. Boot the installer and prepare storage

Boot a [NixOS installation image](https://nixos.org/download/) in UEFI mode, connect to the internet, and open a terminal. Follow the [official installation instructions](https://nixos.org/manual/nixos/stable/#sec-installation-manual) to partition and format your target disk.

Formatting erases the selected partition. Back up your data and identify the devices with `lsblk -f`; preserve an existing EFI partition when sharing it with another OS.

For the layout used by this repository, prepare:

| Mount point | Filesystem | Btrfs subvolume |
| --- | --- | --- |
| `/` | Btrfs | `@` |
| `/home` | Btrfs | `@home` |
| `/nix` | Btrfs | `@nix` |
| `/var/log` | Btrfs | `@log` |
| `/boot` | FAT32 EFI System Partition | — |

The following commands start **after partitioning and formatting**. Run them in a root Bash shell on the live system:

```bash
sudo -i
bash
lsblk -f

# Replace these examples with your actual, already formatted partitions.
root_partition=/dev/nvme0n1p2
efi_partition=/dev/nvme0n1p1

mount "$root_partition" /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@log
umount /mnt

mount -o subvol=@ "$root_partition" /mnt
mkdir -p /mnt/{home,nix,var/log,boot}
mount -o subvol=@home "$root_partition" /mnt/home
mount -o subvol=@nix "$root_partition" /mnt/nix
mount -o subvol=@log "$root_partition" /mnt/var/log
mount "$efi_partition" /mnt/boot
findmnt -R /mnt
```

For ext4 or an existing subvolume layout, mount that layout instead and generate its hardware configuration below. Encryption, RAID, and resume settings also need their own configuration. Swap is optional for normal use; configure suitable disk-backed swap and resume support if you want hibernation.

### 2. Clone the repository

Continue in the root shell. Fetch Git and an editor, then clone into the mounted installation:

```bash
export NIX_CONFIG='experimental-features = nix-command flakes'
nix shell nixpkgs#git nixpkgs#nano

install_host=atlas
install_user=caiocsx

mkdir -p /mnt/etc
git clone https://github.com/caiocsx/nixdots.git /mnt/etc/nixdots
cd /mnt/etc/nixdots
```

Use your fork's URL if you have one. If you create a new host, make sure `install_host` matches its output in `flake.nix`.

### 3. Generate hardware settings and personalize

With all target filesystems mounted:

```bash
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix \
  "hosts/$install_host/hardware-configuration.nix"
```

Complete [Adapt the configuration](customization.md#adapt-the-configuration) now. The generated `/mnt/etc/nixos/configuration.nix` is useful as a reference for installation defaults, but this flake uses the files under `hosts/` and `modules/`.

The `install_user` variable does not rename the NixOS account: update the Nix files too. For a new installation, choose an appropriate initial `system.stateVersion` and `home.stateVersion`; the repository currently uses `26.05`.

Review and stage your configuration so Git-backed flake evaluation includes any new files:

```bash
git diff
git add flake.nix hosts modules
nix flake check --no-build
```

This checks evaluation, not the complete build. The next step builds and installs the selected system.

### 4. Install and set passwords

```bash
nixos-install --root /mnt --flake ".#$install_host"
nixos-enter --root /mnt -c "passwd $install_user"
reboot
```

`nixos-install` prompts for the root password; the second command sets the declared user's password. This repository does not supply one. See the [NixOS installation manual](https://nixos.org/manual/nixos/stable/#sec-installation-installing) for installer details.

### 5. Put the repository in its normal location

After booting, log in as your configured user and run:

```bash
sudo mv /etc/nixdots "$HOME/nixdots"
sudo chown -R "$(id -un):$(id -gn)" "$HOME/nixdots"
cd "$HOME/nixdots"
```

The shell aliases and `nh` configuration expect `~/nixdots`. Your edits and generated hardware file move with the checkout. Commit them to your fork when ready.

The installer-generated files under `/etc/nixos` are separate from this checkout. Use the explicit flake path or the supplied `nh` aliases for future rebuilds.

Continue with [First login](#first-login).

## Existing NixOS installation

This path adopts the full configuration without repartitioning. System services, installed packages, and Home Manager files will follow this repository after activation. For selective reuse, copy and adapt individual modules instead of switching to the complete host output.

### 1. Back up and record your current settings

Back up your current configuration repository, `/etc/nixos`, and home files that will be managed here. Keep a bootable system generation while migrating.

Record your existing `system.stateVersion` and, if already using Home Manager, `home.stateVersion`. Preserve both when adapting this repository. Also retain any custom bootloader, LUKS, filesystem, swap, networking, user UID, and service settings your machine needs.

### 2. Clone and collect hardware settings

Run as your normal user, using `sudo` only where shown. If Git is missing, first enter `nix-shell -p git`.

```bash
git clone https://github.com/caiocsx/nixdots.git "$HOME/nixdots"
cd "$HOME/nixdots"
target_host=atlas

sudo nixos-generate-config --show-hardware-config \
  > "hosts/$target_host/hardware-configuration.nix"
```

Choose an unused checkout directory if `~/nixdots` already exists. Hardware generation does not preserve every custom setting from your current configuration; compare the result with your existing modules, particularly for encrypted storage and boot.

### 3. Adapt the configuration

Follow the [customization checklist](customization.md#adapt-the-configuration). Reuse your existing username and home path, and carry over explicit user/group IDs where relevant to file ownership.

Retain your current bootloader configuration unless you deliberately intend to change it. The shared boot module selects GRUB with the EFI partition at `/boot`; copying the hardware file alone does not preserve a systemd-boot setup.

Home Manager may refuse activation when an existing file occupies a path it wants to manage. Back up and move only the conflicting files it reports, then retry. If you previously used standalone Home Manager, remove its old activation mechanism once the integrated setup takes over.

### 4. Validate and build

```bash
git diff
git add flake.nix hosts modules

nix --extra-experimental-features 'nix-command flakes' flake check --no-build
sudo nixos-rebuild build --flake ".#$target_host" \
  --option extra-experimental-features 'nix-command flakes'
```

The build does not activate the new configuration. Inspect any errors before proceeding.

### 5. Activate

Save your work and apply from a local terminal or TTY; changing the desktop and login manager can interrupt the current session.

```bash
sudo nixos-rebuild switch --flake ".#$target_host" \
  --option extra-experimental-features 'nix-command flakes'
```

If you created a new account, set its password with `sudo passwd YOUR_USERNAME` before logging out. Reboot to enter the new desktop with its kernel, drivers, and session environment.

If activation fails, inspect the error and the Home Manager service log. The [recovery guide](usage.md#recovery) covers rollback and booting a previous generation.

## First login

- Select the Hyprland session managed by UWSM in Ly.
- Open Kitty with `SUPER + Return`, or the shortcut menu with `SUPER + F1`.
- Add your own images to `~/Pictures/Wallpapers` and choose one with `SUPER + W`. Wallpapers are not bundled.
- Review browser accounts, extensions, and application preferences before everyday use.
- If the firmware boots another OS directly, select the NixOS/GRUB UEFI entry and review the firmware boot order.

Continue with [Everyday use](usage.md) for updates and maintenance.
