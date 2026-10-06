{ theme, ... }:
''
  * {
    background:             ${theme.withAlpha theme.colors.background theme.opacity.shell};
    background-solid:       ${theme.colors.background};
    surface:                ${theme.withAlpha theme.colors.surface theme.opacity.shell};
    surface-solid:          ${theme.colors.surface};
    foreground:             ${theme.colors.foreground};
    muted:                  ${theme.colors.muted};
    accent:                 ${theme.colors.accent};
    cyan:                   ${theme.colors.cyan};
    blue:                   ${theme.colors.blue};
    green:                  ${theme.colors.green};
    magenta:                ${theme.colors.magenta};
    orange:                 ${theme.colors.orange};
    purple:                 ${theme.colors.purple};
    red:                    ${theme.colors.red};
    yellow:                 ${theme.colors.yellow};
    radius:                 ${toString theme.borders.radius}px;
  }

  scrollbar {
    handle-rounded-corners: true;
    handle-color:           @accent;
    background-color:       @surface;
  }

  element selected.normal {
    text-color:             @surface-solid;
    background-color:       @accent;
  }

  button selected {
    text-color:             @surface-solid;
    background-color:       @accent;
  }
''
