{ theme, ... }:
''
  window {
    width:            400px;
    border-radius:    @radius;
    background-color: transparent;
  }

  mainbox {
    background-color: transparent;
    children:         [ message, listview ];
  }

  message {
    padding:          20px;
    border-radius:    @radius;
    background-color: @background;
  }

  textbox {
    vertical-align:   0.5;
    horizontal-align: 0.5;
    font:             "${theme.fonts.interface} 11";
    text-color:       @foreground;
    background-color: transparent;
  }

  listview {
    columns:          2;
    lines:            1;
    cycle:            false;
    padding:          20px;
    spacing:          20px;
    border-radius:    @radius;
    background-color: @surface;
  }

  element {
    padding:          10px 5px;
    cursor:           pointer;
    border-radius:    @radius;
    text-color:       @foreground;
    background-color: @background;
  }

  element-text {
    vertical-align:   0.5;
    horizontal-align: 0.5;
    cursor:           inherit;
    font:             "${theme.fonts.interface} 28";
    text-color:       inherit;
    background-color: transparent;
  }
''
