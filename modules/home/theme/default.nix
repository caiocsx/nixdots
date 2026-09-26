{ config, lib, pkgs, ... }:
{
  imports = [
    ./stylix.nix
  ];

  _module.args.theme = import ./tokens.nix {
    inherit config lib pkgs;
  };
}
