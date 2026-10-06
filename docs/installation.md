# Installation

[← README](../README.md) · [Customization](customization.md) · [Everyday use](usage.md)

- [Before you start](#before-you-start)
- [Storage layout](#storage-layout)
- [Clean install — recommended](#clean-install-recommended)
- [First login](#first-login)

## Before you start

This is a personal configuration. Follow the [customization checklist](customization.md#adapt-the-configuration) before installing.

The commands use concrete examples throughout:

| Example | Replace with |
| --- | --- |
| `/dev/nvme0n1` | Your target disk |
| `/dev/nvme0n1p1` | Your EFI partition |
| `/dev/nvme0n1p2` | Your ext4 partition |
| `/dev/nvme0n1p3` | Your swap partition |
| `atlas` | Your selected flake host, such as `hyperion` |
| `caiocsx` | Your username, also updated in the Nix configuration |

Replace these examples directly in commands and configuration files. Use your fork's URL if applicable, and keep `flake.lock` unchanged for the first installation.

The supplied hosts target `x86_64-linux` and UEFI with GRUB. This guide follows the [NixOS manual installation workflow](https://nixos.org/manual/nixos/stable/#sec-installation-installing).

## Storage layout

The installation uses one ext4 filesystem for `/`, a FAT32 EFI partition mounted at `/boot`, and a swap partition for memory pressure and hibernation.

## Clean install (recommended)

### 1. Boot the live USB and connect

Boot a [NixOS installation image](https://nixos.org/download/) in UEFI mode and connect to the internet using Ethernet, the desktop network settings, or `nmtui`. Open a terminal and enter a root shell for the installation:

```bash
sudo -i
```

### 2. Partition and format

Open the target disk in `cfdisk`. For a new disk, choose a GPT partition table and create these partitions:

```bash
cfdisk /dev/nvme0n1
```

| Partition | Size | Type |
| --- | --- | --- |
| `/dev/nvme0n1p1` | 1 GiB | EFI System |
| `/dev/nvme0n1p2` | Remaining space after reserving swap | Linux filesystem |
| `/dev/nvme0n1p3` | Enough for hibernation; size according to your RAM and workload | Linux swap |

Write the changes and quit `cfdisk`. **Formatting erases the selected partitions.** For dual boot, preserve the existing OS partitions and EFI partition; create Linux and swap partitions in available space.

Format the new EFI, ext4, and swap partitions:

```bash
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2
mkswap /dev/nvme0n1p3
swapon /dev/nvme0n1p3
```

Do not format an existing EFI or swap partition you intend to reuse. Encryption requires additional setup.

### 3. Mount the filesystems

```bash
mount /dev/nvme0n1p2 /mnt
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
findmnt -R /mnt
```

### 4. Clone and generate hardware settings

Continue in the installer's root shell:

```bash
mkdir -p /mnt/etc
git clone https://github.com/caiocsx/nixdots.git /mnt/etc/nixdots
cd /mnt/etc/nixdots
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hosts/atlas/hardware-configuration.nix
```

This replaces the selected host's hardware file with settings generated for your machine, including ext4 and the active swap partition.

### 5. Personalize the configuration

Complete [Adapt the configuration](customization.md#adapt-the-configuration) for the selected host and user.

Optionally review your edits before staging:

```bash
git diff
```

Stage changes so the flake includes new files:

```bash
git add -A
```

Optional evaluation check:

```bash
nix --extra-experimental-features 'nix-command flakes' flake check --no-build
```

### 6. Install and set passwords

```bash
nixos-install --root /mnt --flake .#atlas --option extra-experimental-features 'nix-command flakes'
nixos-enter --root /mnt -c 'passwd caiocsx'
reboot
```

The installer prompts for the root password; the second command sets your user's password. Remove the installation media when rebooting.

### 7. Move the checkout after login

Log in as your configured user and move the repository into the location expected by the shell aliases and `nh`:

```bash
sudo mv /etc/nixdots /home/caiocsx/nixdots
sudo chown -R caiocsx:users /home/caiocsx/nixdots
cd /home/caiocsx/nixdots
```

Adjust the account, group, and home path if needed. Use this checkout for future rebuilds.

## First login

- Select the Hyprland session managed by UWSM in Ly.
- Open Kitty with `SUPER + Return`, or the shortcut menu with `SUPER + F1`.
- Add images to `~/Pictures/Wallpapers` and choose one with `SUPER + W`. Wallpapers are not bundled.
- Review browser accounts, extensions, and application preferences.
- Check swap with `swapon --show` and test hibernation using the [memory and swap guide](usage.md#memory-and-swap).

Continue with [Everyday use](usage.md) for updates and maintenance.
