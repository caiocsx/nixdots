{ theme, ... }:
''
  configuration {
    font:              "${theme.fonts.monospace.proportional} 10";
    show-icons:        true;
  }

  window {
    width:             820px;
    height:            760px;
    padding:           20px;
    border-radius:     @radius;
    background-color:  @background;
  }

  mainbox {
    orientation:       vertical;
    spacing:           20px;
    background-color:  transparent;
    children:          [ inputbar, listview, textbox-hint ];
  }

  inputbar {
    padding:           12px;
    spacing:           15px;
    border-radius:     @radius;
    background-color:  @surface;
    children:          [ textbox-prompt-colon, entry ];
  }

  textbox-prompt-colon {
    str:               "󰊗";
    text-color:        @foreground;
    expand:            false;
    background-color:  transparent;
  }

  entry {
    placeholder:       "Search games...";
    placeholder-color: @muted;
    cursor:            text;
    text-color:        @foreground;
    background-color:  transparent;
  }

  listview {
    layout:            vertical;
    flow:              horizontal;
    columns:           3;
    lines:             2;
    spacing:           12px;
    scrollbar:         true;
    cycle:             false;
    dynamic:           true;
    fixed-height:      true;
    fixed-columns:     true;
    background-color:  transparent;
  }

  element {
    children:          [ element-icon, element-text ];
    orientation:       vertical;
    padding:           8px;
    spacing:           8px;
    border:            2px;
    border-color:      transparent;
    border-radius:     @radius;
    cursor:            pointer;
    text-color:        @foreground;
    background-color:  @surface-solid;
  }

  element selected.normal {
    border-color:      @accent;
    text-color:        @foreground;
    background-color:  @surface-solid;
  }

  element-icon {
    size:              210px;
    horizontal-align:  0.5;
    vertical-align:    0.5;
    cursor:            inherit;
    background-color:  transparent;
  }

  element-text {
    horizontal-align:  0.5;
    vertical-align:    0.5;
    cursor:            inherit;
    text-color:        inherit;
    background-color:  transparent;
  }

  textbox-hint {
    str:               "Enter: launch   ·   Shift+Enter: game folder";
    horizontal-align:  0.5;
    expand:            false;
    text-color:        @muted;
    background-color:  transparent;
  }
''
