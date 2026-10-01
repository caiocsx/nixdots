<div align="center">

# nixdots

**My personal NixOS desktop, built around Hyprland.**

![GitHub last commit](https://img.shields.io/github/last-commit/caiocsx/nixdots?style=for-the-badge)
[![Check](https://img.shields.io/github/actions/workflow/status/caiocsx/nixdots/test.yml?branch=main&style=for-the-badge&label=check)](https://github.com/caiocsx/nixdots/actions/workflows/test.yml)
[![License](https://img.shields.io/github/license/caiocsx/nixdots?style=for-the-badge)](LICENSE)

[Installation](docs/installation.md) · [Customization](docs/customization.md) · [Everyday use](docs/usage.md)

</div>

## Overview

A modular configuration for my desktop and laptop, using Nix flakes to pin dependencies and Home Manager to manage user applications alongside the operating system. Shared modules keep both machines consistent; host files hold hardware and display settings.

The desktop combines Hyprland, small focused utilities, and a Nord theme shared through Stylix. This is a personal setup you can fork and adapt: usernames, disks, monitors, and application preferences are specific to my machines.

## Desktop

| Area | Components |
| --- | --- |
| Session | Hyprland, UWSM, Ly |
| Panel and menus | Waybar, Rofi, SwayNotificationCenter |
| Appearance | Stylix, Nord, Papirus, Bibata, JetBrains Mono Nerd Font |
| Screen and wallpaper | Hyprlock, Hypridle, Hyprsunset, awww |
| Everyday apps | Kitty, Thunar, Zen Browser, VSCodium, mpv, imv |
| Terminal tools | Zsh, Starship, Atuin, fzf, zoxide, Nixvim |
| Desktop utilities | Clipboard history, screenshots, calculator, emoji picker, wallpaper picker |
| System services | PipeWire, NetworkManager, Bluetooth, Docker, Flatpak |

## Hosts

| Host | Machine | Graphics | Keyboard | Steam |
| --- | --- | --- | --- | --- |
| `atlas` | Desktop | NVIDIA | US international | Enabled |
| `hyperion` | Laptop | AMD | Brazilian | Disabled |

Both hosts target `x86_64-linux`, track `nixos-unstable`, and use `caiocsx` as the primary user. The checked-in storage configuration uses Btrfs subvolumes and GRUB with UEFI.

## Installation

**A clean install is recommended** for adopting the complete setup. It gives you a fresh base for the system services and Home Manager files managed here.

| Starting point | Guide |
| --- | --- |
| A fresh NixOS installation from a live USB | [Clean install — recommended](docs/installation.md#clean-install-recommended) |
| An existing NixOS installation | [Migrate an existing system](docs/installation.md#existing-nixos-installation) |

Both paths cover generating your own hardware configuration, adapting the host and user, building, and the first login. Existing installations also need their boot settings, state versions, and managed home files reviewed before activation.

> The hardware files contain my disk UUIDs. Replace them with your own before installing. Start with the [installation guide](docs/installation.md), rather than rebuilding an unchanged clone.

Home Manager is integrated into the NixOS configuration, so one system rebuild applies both layers. The flake exposes `nixosConfigurations`; installation uses `nixos-install` or `nixos-rebuild`.

## Project structure

```text
.
├── flake.nix                 # Inputs, shared wiring, and host outputs
├── flake.lock                # Pinned dependency revisions
├── hosts/
│   ├── atlas/                # NVIDIA desktop
│   └── hyperion/             # AMD laptop
├── modules/
│   ├── nixos/
│   │   ├── core/             # Boot, users, locale, and Nix settings
│   │   ├── desktop/          # System-side Hyprland setup
│   │   ├── hardware/         # GPU drivers
│   │   ├── programs/         # Steam, Thunar, and Zsh
│   │   ├── services/         # Audio, networking, login, and more
│   │   └── theme/            # Stylix palette, fonts, icons, and cursor
│   └── home/
│       ├── desktop/          # Hyprland, Waybar, Rofi, and scripts
│       ├── programs/         # CLI and GUI application configuration
│       ├── theme/            # Shared theme tokens and target overrides
│       └── xdg/              # MIME associations, launchers, and directories
├── docs/                     # Installation, customization, and usage guides
└── .github/workflows/        # Flake validation
```

Each host contains `configuration.nix`, `hardware-configuration.nix`, and `home.nix`. Modules are connected through explicit `imports`; new files must be imported to take effect. See [Customization](docs/customization.md) for where to make changes or add a host.

## Getting around

`SUPER` is usually the Windows key. Press **`SUPER + F1`** for the searchable shortcut menu generated from the configured bindings.

| Shortcut | Action |
| --- | --- |
| `SUPER + Return` | Open Kitty |
| `SUPER + Space` | Open the application launcher |
| `SUPER + E` / `SUPER + B` / `SUPER + D` | Open Thunar / Zen Browser / VSCodium |
| `SUPER + W` | Choose a wallpaper |
| `SUPER + V` | Open clipboard history |
| `SUPER + Print` | Copy a selected screen region |
| `SUPER + 1`–`9` | Switch workspace |
| `SUPER + Q` | Close the active window |
| `SUPER + Alt + L` | Lock the screen |
| `SUPER + Escape` | Open the power menu |

The [usage guide](docs/usage.md) covers wallpapers, rebuilds, updates, shell aliases, and recovery.

## License

[MIT](LICENSE).
