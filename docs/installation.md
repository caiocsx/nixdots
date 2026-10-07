# Installation

## Before you start

This is a personal configuration with many machine- and user-specific settings. It is strongly recommended to fork it, adapt the selected host and user using the [customization checklist](customization.md#adapt-the-configuration), and push your changes before booting the installer. Editing the configuration in the live environment is possible, but means changing several files with the tools available there, such as `nano`. During installation, clone the repository you prepared and generate the hardware configuration for the target machine.

The commands use concrete examples throughout:

| Example | Replace with |
| --- | --- |
| `/dev/nvme0n1` | Your target disk |
| `/dev/nvme0n1p1` | Your EFI partition |
| `/dev/nvme0n1p2` | Your ext4 partition |
| `/dev/nvme0n1p3` | Your swap partition |
| `atlas` | Your selected flake host, such as `hyperion` |
| `caiocsx` | Your username, also updated in the Nix configuration |
| `/home/caiocsx` | Your configured home directory |
| `users` | Your primary user group, if you changed it in the Nix configuration |

Replace these examples directly in commands and configuration files. Keep `flake.lock` unchanged for the first installation.

The supplied hosts target `x86_64-linux` and UEFI with GRUB. This guide follows the [NixOS manual installation workflow](https://nixos.org/manual/nixos/stable/#sec-installation-installing).

## Storage layout

The example uses one ext4 filesystem for `/`, a FAT32 EFI partition mounted at `/boot`, and a Linux swap partition.

## Install from a live USB

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
| `/dev/nvme0n1p3` | Size according to your available space and expected memory use | Linux swap |

Write the changes and quit `cfdisk`. **Formatting erases the selected partitions.** For dual boot, preserve the existing OS partitions and EFI partition; create Linux and swap partitions in available space.

These commands are for new partitions on a dedicated disk. For dual boot, substitute the actual partition paths and do not run `mkfs.fat` or `mkswap` on an existing EFI or swap partition you intend to reuse; format only the new Linux and swap partitions.

Format the partitions:

```bash
mkfs.fat -F 32 -n boot /dev/nvme0n1p1
mkfs.ext4 -L nixos /dev/nvme0n1p2
mkswap /dev/nvme0n1p3
swapon /dev/nvme0n1p3
```

Encryption requires additional setup.

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
git add -A
```

Replace the clone URL with your fork's URL. This replaces the selected host's hardware file with settings generated for your machine. Stage the generated file so the Git-backed flake includes it.

### 5. Install and set passwords

```bash
nixos-install --root /mnt --flake .#atlas --option extra-experimental-features 'nix-command flakes'
nixos-enter --root /mnt -c 'passwd caiocsx'
reboot
```

The installer prompts for the root password; the second command sets your user's password. Remove the installation media when rebooting.

### 6. Move the checkout after login

Log in as your configured user and move the repository into the location expected by the shell aliases and `nh`:

```bash
sudo mv /etc/nixdots /home/caiocsx/nixdots
sudo chown -R caiocsx:users /home/caiocsx/nixdots
cd /home/caiocsx/nixdots
```

Keep the checkout at `~/nixdots`; `nh` and the shell aliases use that path to find the flake for future rebuilds.

For first-login steps, see [Everyday use](usage.md#first-login).
