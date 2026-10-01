# Customization

[← README](../README.md) · [Installation](installation.md) · [Everyday use](usage.md)

## Adapt the configuration

Work through these settings before the first installation or migration.

| Setting | Where to edit | What to check |
| --- | --- | --- |
| Hardware and storage | `hosts/<host>/hardware-configuration.nix` | Generate this on your machine; never reuse the committed disk UUIDs. |
| Host and GPU | `hosts/<host>/configuration.nix` | Hostname, hardware module import, system keyboard, optional Steam import. |
| Monitors and input | `hosts/<host>/home.nix` | Output name, resolution, refresh rate, scale, Hyprland keyboard, touchpad settings. |
| Boot | `modules/nixos/core/boot.nix` | GRUB, UEFI, `/boot`, and any settings needed for your storage setup. |
| User account | `modules/nixos/core/users.nix` | Username, groups, and any required UID or account settings. |
| Home directory | `modules/home/default.nix` | `home.username`, `home.homeDirectory`, and `home.stateVersion`. |
| Locale and time | `modules/nixos/core/system-defaults.nix` | Defaults are `en_US.UTF-8` and `America/Recife`. |
| Git identity | `modules/home/programs/cli/git.nix` | Replace the author name and email. |
| System state version | `hosts/<host>/configuration.nix` | Preserve the existing value on a migrated system. |

### Rename the user consistently

The username is declared in several places. Update the `caiocsx` account references in:

- [`flake.nix`](../flake.nix): the shared Home Manager user.
- [`modules/nixos/core/users.nix`](../modules/nixos/core/users.nix): the NixOS account.
- [`modules/nixos/services/docker.nix`](../modules/nixos/services/docker.nix) and [`network-manager.nix`](../modules/nixos/services/network-manager.nix): group memberships.
- Each `hosts/<host>/configuration.nix`: the host-specific Home Manager import.
- [`modules/home/default.nix`](../modules/home/default.nix): the Home Manager username and home directory.

Search for remaining references with `rg -n 'caiocsx' flake.nix hosts modules` if ripgrep is available. Review matches individually; repository URLs and author metadata are separate choices.

The current setup shares one Home Manager user across both hosts. Renaming that shared user means updating both hosts, even if you only intend to install one.

### Check hardware-specific assumptions

Atlas imports the NVIDIA module and sets NVIDIA environment variables in its `home.nix`. Hyperion imports the AMD module and configures the laptop display and touchpad. Remove or adapt those settings when changing GPUs; copying just the generated hardware file is not enough.

When running Hyprland, `hyprctl monitors` lists detected output names and modes. Set the matching values in the host's `home.nix`. Configure the system keyboard in `configuration.nix` and the compositor keyboard in `home.nix`.

### Keep state versions stable

`system.stateVersion` and `home.stateVersion` select compatibility defaults; they do not select package versions. Keep the previous values when migrating an existing installation. Package revisions come from `flake.lock`. See the [NixOS configuration documentation](https://wiki.nixos.org/wiki/NixOS_system_configuration) for background.

## Add a host

Use an existing host as a starting point. For example, from the repository root:

```bash
cp -r hosts/hyperion hosts/myhost
```

Replace `hosts/myhost/hardware-configuration.nix` with the file generated for the target machine using the appropriate [installation workflow](installation.md). Do this before building: the copied hardware file still refers to Hyperion's disks.

Edit `configuration.nix` and `home.nix` for your hardware, then add an entry next to `atlas` and `hyperion` inside `nixosConfigurations` in [`flake.nix`](../flake.nix):

```nix
myhost = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = commonModules ++ [ ./hosts/myhost/configuration.nix ];
};
```

Set `networking.hostName = "myhost";` in the new host configuration. Matching the hostname and flake output lets the default `nh` workflow select the right host.

```bash
git add flake.nix hosts/myhost
nix flake check --no-build
sudo nixos-rebuild build --flake .#myhost
```

`flake.nix` is maintained by hand. New modules are loaded only when referenced by an `imports` list, and new files must be added to Git for Git-backed flakes to include them. See the [NixOS flakes guide](https://wiki.nixos.org/wiki/Flakes).

## Change the desktop

| Change | File or directory |
| --- | --- |
| Palette, fonts, icons, cursor | [`modules/nixos/theme/stylix.nix`](../modules/nixos/theme/stylix.nix) |
| Shared colors, spacing, opacity, blur | [`modules/home/theme/tokens.nix`](../modules/home/theme/tokens.nix) |
| Hyprland behavior and rules | [`modules/home/desktop/hyprland/config/`](../modules/home/desktop/hyprland/config/) |
| Shortcuts and application commands | [`binds.nix`](../modules/home/desktop/hyprland/config/binds.nix) |
| Panel modules and styling | [`waybar.nix`](../modules/home/desktop/components/waybar.nix) |
| Rofi scripts and themes | [`modules/home/desktop/components/rofi/`](../modules/home/desktop/components/rofi/) |
| Lock screen and idle behavior | [`hyprlock.nix`](../modules/home/desktop/components/hyprlock.nix), [`hypridle.nix`](../modules/home/desktop/components/hypridle.nix) |
| Default applications and launcher entries | [`modules/home/xdg/`](../modules/home/xdg/) |

Stylix supplies the base palette and fonts; the custom desktop components consume the shared theme tokens. Start there when changing the overall appearance.

The `apps` set in `binds.nix` defines the terminal, file manager, browser, editor, and system monitor commands. When replacing one, also update its package/module, relevant MIME associations, and desktop entry overrides. The keybind menu reads descriptions from this same file; its workspace summarizer also depends on the `Workspace:` description pattern.

## Add packages or modules

Use `modules/home/programs/cli/packages.nix` or `gui/packages.nix` for shared user packages. A package specific to one machine belongs in that host's `home.nix`.

For an application with configuration, create a module next to similar programs and add it to the directory's `default.nix` imports. System services belong under `modules/nixos/`; user programs and desktop preferences belong under `modules/home/`.

New flake inputs go in `flake.nix`. The existing `specialArgs` and `extraSpecialArgs` wiring makes `inputs` available to NixOS and Home Manager modules.

After editing, [validate and rebuild](usage.md#apply-changes).
