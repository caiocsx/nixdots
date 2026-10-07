{ theme, ... }:
''
  configuration {
    font:              "${theme.fonts.monospace.proportional} 10";
    show-icons:        true;
  }

  window {
    width:             960px;
    height:            840px;
    padding:           20px;
    border-radius:     @radius;
    background-color:  @background;
  }

  mainbox {
    spacing:           20px;
    orientation:       vertical;
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
    columns:           4;
    lines:             2;
    scrollbar:         true;
    cycle:             false;
    dynamic:           true;
    flow:              horizontal;
    fixed-height:      true;
    fixed-columns:     true;
    spacing:           12px;
    background-color:  transparent;
  }

  element {
    orientation:       vertical;
    padding:           5px;
    spacing:           5px;
    cursor:            pointer;
    border-radius:     @radius;
    text-color:        @foreground;
    background-color:  @surface-solid;
  }

  element-icon {
    horizontal-align:  0.5;
    vertical-align:    0.5;
    size:              310px;
    cursor:            inherit;
    border-radius:     @radius;
  }

  element-text {
    horizontal-align:  0.5;
    cursor:            inherit;
    text-color:        inherit;
    background-color:  transparent;
  }

  textbox-hint {
    str:               "Enter: launch · Shift+Enter: game folder";
    horizontal-align:  0.5;
    expand:            false;
    text-color:        @muted;
    background-color:  transparent;
  }
''
