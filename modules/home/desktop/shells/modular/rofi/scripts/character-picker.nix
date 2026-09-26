{
  config,
  pkgs,
  theme,
  ...
}:

let
  themes = import ../themes { inherit config pkgs theme; };

  characterPicker = pkgs.writeShellApplication {
    name = "character-picker";
    runtimeInputs = with pkgs; [
      rofi
      rofimoji
      wl-clipboard
      wtype
    ];
    text = ''
      rofi -modi "emoji:rofimoji --action copy --use-icons --hidden-descriptions
      --files emojis nerd_font math latin-1_supplement" \
      -kb-row-left Left \
      -kb-row-right Right \
      -kb-move-char-back Control+b \
      -kb-move-char-forward Control+f \
      -show emoji \
      -theme "${themes.characterPicker}"
    '';
  };
in
{
  home.packages = [
    characterPicker
  ];
}
