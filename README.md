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

The shared configuration includes the following desktop components and applications. Host-specific options are listed under [Hosts](#hosts).

| Desktop component | What is configured |
| --- | --- |
| Compositor and session | Hyprland window management, UWSM session management, Ly login manager |
| Status bar and notifications | Waybar and SwayNotificationCenter |
| Launcher and menus | Rofi application launcher, power menu, shortcut viewer, calculator, character picker, and wallpaper picker |
| Locking and idle behavior | Hyprlock screen lock and Hypridle idle actions |
| Wallpaper and display temperature | awww wallpapers and Hyprsunset color temperature control |
| Clipboard and screenshots | Cliphist history; grim and slurp capture; Swappy annotation |
| Theme, icons, and fonts | Stylix with a configurable palette, Papirus icons, Bibata cursor, Inter, Noto fonts, and JetBrains Mono Nerd Font |

| Applications and terminal | What is included |
| --- | --- |
| Terminal and shell | Kitty, Zsh, Starship prompt, Atuin history, fzf search, zoxide navigation |
| Editors and development | VSCodium, Neovim through Nixvim, Git, direnv |
| Files and browsing | Thunar and Zen Browser |
| Media and communication | mpv, imv, Spotify, Stremio, Discord |
| Productivity and Proton apps | Obsidian, ONLYOFFICE, Proton Mail, Proton Pass, Proton VPN |
| System inspection and maintenance | btop, Fastfetch, nh rebuild and cleanup commands |

| System integration | What is enabled |
| --- | --- |
| Audio | PipeWire |
| Connectivity | NetworkManager and Bluetooth |
| Containers and application distribution | Docker and Flatpak |

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
│       ├── desktop/          # Hyprland, Waybar, Rofi, and scripts
│       ├── programs/         # CLI and GUI application configuration
│       ├── theme/            # Shared theme tokens and target overrides
│       └── xdg/              # MIME associations, launchers, and directories
├── templates/                # Catalog and standalone development environment templates
├── docs/                     # Installation, customization, usage, and development guides
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
| `SUPER + X` | Show or hide Waybar |
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
