{
  config,
  pkgs,
  theme,
  ...
}:
let
  common = import ./common.nix { inherit theme; };
  mkTheme = name: content: pkgs.writeText "${name}.rasi" (common + content);
in
{
  calculator = mkTheme "calculator" (import ./calculator.nix { inherit theme; });


  confirm = mkTheme "confirm" (import ./confirm.nix { inherit theme; });

  listMenu = mkTheme "list-menu" (import ./list-menu.nix { inherit theme; });

  powerMenu = mkTheme "power-menu" (import ./power-menu.nix { inherit config theme; });

  launcher = mkTheme "launcher" (import ./launcher.nix { inherit config theme; });

  characterPicker = mkTheme "character-picker" (import ./character-picker.nix { inherit theme; });

  wallpaperPicker = mkTheme "wallpaper-picker" (import ./wallpaper-picker.nix { inherit theme; });
}
