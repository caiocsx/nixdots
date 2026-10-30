<div align="center">

# nixdots

**My personal NixOS desktop, built around Hyprland.**

![GitHub last commit](https://img.shields.io/github/last-commit/caiocsx/nixdots?style=for-the-badge&)
![GitHub Repo stars](https://img.shields.io/github/stars/caiocsx/nixdots?style=for-the-badge&)
![GitHub repo size](https://img.shields.io/github/repo-size/caiocsx/nixdots?style=for-the-badge&)

[Installation](docs/installation.md) · [Customization](docs/customization.md) · [Everyday use](docs/usage.md) · [Development templates](docs/development.md)

</div>

## Overview

A modular NixOS configuration built around Hyprland, using Nix flakes to pin dependencies and Home Manager to manage user applications alongside the operating system. Shared modules define the system and desktop; host files hold hardware and display settings. Stylix centralizes theming, so you can choose your own palette, fonts, icons, and cursor.

> [!IMPORTANT]
> **This is a personal setup, not a general-purpose configuration.** Use it as a reference, reuse individual modules, or fork and adapt it to your needs. Applying it unchanged will carry over my username, Git identity, disk and boot settings, monitor configuration, keyboard layouts, locale, and application preferences. Review the [customization checklist](docs/customization.md#adapt-the-configuration) before installing; these settings are not automatically adapted to your machine.

## Desktop

The shared configuration installs and configures the following desktop components, applications, and system integrations. Host-specific options are listed under [Hosts](#hosts).

| Area | Installed and configured |
| --- | --- |
| Compositor and session | Hyprland, UWSM, Ly |
| Desktop shell | Waybar, SwayNotificationCenter, Vicinae, Hyprlock, Hypridle |
| Desktop utilities | Clipboard, power, emoji, wallpaper, and screenshot tools |
| Wallpaper and display | awww, Hyprsunset |
| Theme, icons, and fonts | Stylix, Papirus, Bibata, Inter, Noto, JetBrains Mono Nerd Font |
| Terminal and shell | Kitty, Zsh, Starship, fzf, Fastfetch, zoxide |
| Editors and development | VSCodium, Neovim, Mousepad, Git, direnv |
| Files and browsing | Thunar, Xarchiver, Zen Browser |
| Media and communication | mpv, imv, Spotify, Discord |
| System monitoring | btop |
| NixOS maintenance | nh rebuild and cleanup |
| Backups | Scheduled Restic backups |
| Audio and connectivity | PipeWire, NetworkManager, Bluetooth |
| Containers and application distribution | Docker, Flatpak |

## Hosts

| Host | Machine | Graphics | Keyboard | Steam |
| --- | --- | --- | --- | --- |
| `atlas` | Desktop | NVIDIA | US international | Enabled |
| `hyperion` | Laptop | AMD | Brazilian | Disabled |

Both hosts target `x86_64-linux`, track `nixos-unstable`, and use `caiocsx` as the primary user. The installation guide uses ext4, GRUB, and UEFI.

## Installation

For a fresh NixOS installation from a live USB, follow the [installation guide](docs/installation.md). It covers adapting the host and user, generating the hardware configuration, and installing the system.

> The hardware files contain my disk UUIDs. Replace them with your own before installing. Start with the [installation guide](docs/installation.md), rather than rebuilding an unchanged clone.

Home Manager is integrated into the NixOS configuration, so one system rebuild applies both layers. The flake exposes `nixosConfigurations` and independent development templates; installation uses `nixos-install` or `nixos-rebuild`.

## Development templates

List available templates with `nix flake show ~/nixdots`, then copy one into a project with `nix flake init -t ~/nixdots#TEMPLATE_NAME`, replacing `TEMPLATE_NAME` with a name from the catalog. Each project owns its flake and generates its own lock file, with no dependency on nixdots after initialization. See the [development guide](docs/development.md) for setup, direnv, sharing projects, and adding templates.

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
│       ├── desktop/          # Hyprland, Waybar, Vicinae, and scripts
│       ├── programs/         # CLI and GUI application configuration
│       ├── theme/            # Shared theme tokens and target overrides
│       └── xdg/              # MIME associations, launchers, and directories
├── templates/                # Catalog and standalone development environment templates
├── docs/                     # Installation, customization, usage, and development guides
└── .github/workflows/        # Flake validation
```

Each host contains `configuration.nix`, `hardware-configuration.nix`, and `home.nix`. Modules are connected through explicit `imports`; new files must be imported to take effect. See [Customization](docs/customization.md) for where to make changes or add a host.

## Getting around

`SUPER` is usually the Windows key. The shortcuts below are configured in Hyprland; see the [usage guide](docs/usage.md) for workspace behavior and more details.

| Shortcut | Action |
| --- | --- |
| `SUPER + Return` | Open terminal |
| `SUPER + Space` | Open launcher |
| `SUPER + E` / `SUPER + B` / `SUPER + D` | Open Thunar / Zen Browser / VSCodium |
| `SUPER + W` | Choose a wallpaper |
| `SUPER + V` | Open clipboard history |
| `SUPER + Alt + K` | Search Hyprland keybinds |
| `SUPER + Escape` | Open power menu |
| `SUPER + Print` | capture selected region |
| `SUPER + 1`–`9` | Switch workspace |
| `SUPER + Q` | Close the active window |
| `SUPER + H` / `J` / `K` / `L` | Focus left / down / up / right |
| `SUPER + Shift + H` / `J` / `K` / `L` | Move window left / down / up / right |
| `SUPER + Ctrl + L` | Lock the screen |

The [usage guide](docs/usage.md) covers shell aliases, updates, wallpapers, and more.

## License

[MIT](LICENSE).
