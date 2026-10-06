{ config, lib, pkgs, ... }:
let
  lua = lib.generators.mkLuaInline;

  apps = {
    terminal = config.home.sessionVariables.TERMINAL;
    fileManager = config.home.sessionVariables.FILE_MANAGER;
    browser = config.home.sessionVariables.BROWSER;
    editor = config.home.sessionVariables.EDITOR;
    systemMonitor = config.home.sessionVariables.SYSTEM_MONITOR;
  };

  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    app = cmd: lua ''hl.dsp.exec_cmd("uwsm app -- ${cmd}")'';
    close = lua "hl.dsp.window.close()";
    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
    floatSized =
      x: y:
      lua ''
        function()
          hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
          hl.dispatch(hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, exact = true }))
          hl.dispatch(hl.dsp.window.center())
        end
      '';
    kill = lua "hl.dsp.window.kill()";
    maximize = lua "hl.dsp.window.fullscreen({ maximize = true })";
    pseudo = lua "hl.dsp.window.pseudo()";
    layout = msg: lua ''hl.dsp.layout("${msg}")'';
    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
    moveToSpecialSilent =
      name: lua ''hl.dsp.window.move({ workspace = "special:${name}", follow = false })'';
    focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
    moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
    moveToWorkspaceSilent =
      ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}", follow = false })'';
    drag = lua "hl.dsp.window.drag()";
    resize = lua "hl.dsp.window.resize()";
    resizeActive =
      x: y: lua "hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })";
  };

  bind = keys: description: dispatcher: {
    _args = [
      keys
      dispatcher
      { inherit description; }
    ];
  };
  bindOpts = keys: description: dispatcher: opts: {
    _args = [
      keys
      dispatcher
      (opts // { inherit description; })
    ];
  };

  workspaceBinds = lib.concatMap (i: [
    (bind "SUPER + ${toString i}" "Workspace: switch to workspace ${toString i}" (dsp.focusWorkspace i))
    (bind "SUPER + SHIFT + ${toString i}" "Workspace: move window to workspace ${toString i} and follow"
      (dsp.moveToWorkspace i)
    )
    (bind "SUPER + ALT + ${toString i}"
      "Workspace: move window to workspace ${toString i} without following"
      (dsp.moveToWorkspaceSilent i)
    )
  ]) (lib.range 1 9);
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # --- Applications ---
      (bind "SUPER + Return" "Applications: open terminal" (dsp.app apps.terminal))
      (bind "SUPER + SPACE" "Applications: open application launcher" (dsp.exec "launcher"))
      (bind "SUPER + E" "Applications: open file manager" (dsp.app apps.fileManager))
      (bind "SUPER + B" "Applications: open web browser" (dsp.app apps.browser))
      (bind "SUPER + D" "Applications: open code editor" (dsp.app apps.editor))
      (bind "SUPER + SHIFT + ESCAPE" "Applications: open system monitor" (
        dsp.app "${apps.terminal} -e ${apps.systemMonitor}"
      ))
      (bind "SUPER + G" "Applications: open game launcher" (dsp.exec "game-launcher"))
      (bind "SUPER + EQUAL" "Applications: open calculator" (dsp.exec "calculator"))
      (bind "SUPER + period" "Clipboard: copy emoji or symbol from character picker" (
        dsp.exec "character-picker"
      ))

      # --- System ---
      (bind "SUPER + F1" "System: search keyboard shortcuts and keybinds" (dsp.exec "keybinds"))
      (bind "SUPER + U" "System: manage systemd user services" (dsp.exec "unit-menu"))

      # --- Session ---
      (bind "SUPER + SHIFT + Delete" "Session: shut down computer" (
        dsp.exec "${pkgs.hyprshutdown}/bin/hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0'"
      ))
      (bind "SUPER + ALT + Delete" "Session: reboot computer" (
        dsp.exec "${pkgs.hyprshutdown}/bin/hyprshutdown -t 'Restarting...' --post-cmd reboot"
      ))
      (bind "SUPER + Delete" "Session: log out of Hyprland session" (
        dsp.exec "${pkgs.hyprshutdown}/bin/hyprshutdown"
      ))
      (bind "SUPER + ESCAPE" "Session: open power menu" (dsp.exec "power-menu"))
      (bind "SUPER + ALT + L" "Session: lock screen" (dsp.exec "hyprlock"))

      # --- Notifications ---
      (bind "SUPER + A" "Notifications: toggle SwayNC control center" (dsp.exec "swaync-client -t -sw"))

      # --- Wallpaper ---
      (bind "SUPER + W" "Wallpaper: open wallpaper picker" (dsp.exec "wallpaper-picker"))
      (bind "SUPER + ALT + bracketleft" "Wallpaper: apply previous wallpaper" (
        dsp.exec "wallpaper-picker --prev"
      ))
      (bind "SUPER + ALT + bracketright" "Wallpaper: apply next wallpaper" (
        dsp.exec "wallpaper-picker --next"
      ))

      # --- Clipboard ---
      (bind "SUPER + V" "Clipboard: search and copy from history" (dsp.exec "clipboard"))
      (bind "SUPER + SHIFT + V" "Clipboard: clear history" (dsp.exec "clipboard --wipe"))

      # --- Screenshot ---
      (bind "SUPER + PRINT" "Screenshot: copy selected region to clipboard" (
        dsp.exec "screenshot --region --copy"
      ))
      (bind "SUPER + SHIFT + PRINT" "Screenshot: copy selected window to clipboard" (
        dsp.exec "screenshot --window --copy"
      ))
      (bind "SUPER + CTRL + PRINT" "Screenshot: copy selected monitor to clipboard" (
        dsp.exec "screenshot --output --copy"
      ))
      (bind "SUPER + ALT + PRINT" "Screenshot: edit selected region in Swappy" (
        dsp.exec "screenshot --region"
      ))
      (bind "SUPER + ALT + SHIFT + PRINT" "Screenshot: edit selected window in Swappy" (
        dsp.exec "screenshot --window"
      ))
      (bind "SUPER + ALT + CTRL + PRINT" "Screenshot: edit selected monitor in Swappy" (
        dsp.exec "screenshot --output"
      ))

      # --- Accessibility ---
      (bind "SUPER + ALT + mouse_up" "Accessibility: zoom screen to 150%" (
        lua "function() hl.config({ cursor = { zoom_factor = 1.5 } }) end"
      ))
      (bind "SUPER + ALT + mouse_down" "Accessibility: reset screen zoom to 100%" (
        lua "function() hl.config({ cursor = { zoom_factor = 1.0 } }) end"
      ))

      # --- Window ---
      (bind "SUPER + M" "Window: toggle maximized state" dsp.maximize)
      (bind "SUPER + Q" "Window: close active window" dsp.close)
      (bind "SUPER + SHIFT + Q" "Window: force kill a window" dsp.kill)
      (bind "SUPER + SHIFT + W" "Window: toggle floating mode and center at 1000x660" (
        dsp.floatSized 1000 660
      ))
      (bind "SUPER + ALT + W" "Window: toggle floating mode" dsp.float)

      # --- Layout ---
      (bind "SUPER + P" "Layout: toggle pseudo tiling" dsp.pseudo)
      (bind "SUPER + T" "Layout: toggle window split orientation" (dsp.layout "togglesplit"))
      (bind "SUPER + bracketleft" "Layout: decrease window split ratio" (dsp.layout "splitratio -0.05"))
      (bind "SUPER + bracketright" "Layout: increase window split ratio" (dsp.layout "splitratio +0.05"))

      # --- Window / Focus ---
      (bind "SUPER + H" "Window / Focus: focus window on the left" (dsp.focus "left"))
      (bind "SUPER + L" "Window / Focus: focus window on the right" (dsp.focus "right"))
      (bind "SUPER + K" "Window / Focus: focus window above" (dsp.focus "up"))
      (bind "SUPER + J" "Window / Focus: focus window below" (dsp.focus "down"))

      # --- Window / Move ---
      (bind "SUPER + SHIFT + H" "Window / Move: swap position with window on the left" (dsp.swap "left"))
      (bind "SUPER + SHIFT + L" "Window / Move: swap position with window on the right" (
        dsp.swap "right"
      ))
      (bind "SUPER + SHIFT + K" "Window / Move: swap position with window above" (dsp.swap "up"))
      (bind "SUPER + SHIFT + J" "Window / Move: swap position with window below" (dsp.swap "down"))
      (bindOpts "SUPER + mouse:272" "Window / Move: move window by dragging with mouse" dsp.drag {
        mouse = true;
      })

      # --- Window / Resize ---
      (bindOpts "SUPER + SHIFT + Right" "Window / Resize: increase width" (dsp.resizeActive 30 0) {
        repeating = true;
      })
      (bindOpts "SUPER + SHIFT + Left" "Window / Resize: decrease width" (dsp.resizeActive (-30) 0) {
        repeating = true;
      })
      (bindOpts "SUPER + SHIFT + Up" "Window / Resize: decrease height" (dsp.resizeActive 0 (-30)) {
        repeating = true;
      })
      (bindOpts "SUPER + SHIFT + Down" "Window / Resize: increase height" (dsp.resizeActive 0 30) {
        repeating = true;
      })
      (bindOpts "SUPER + mouse:273" "Window / Resize: resize window by dragging with mouse" dsp.resize {
        mouse = true;
      })

      # --- Workspace ---
      (bind "SUPER + CTRL + Right" "Workspace: switch to next workspace" (dsp.focusWorkspace "r+1"))
      (bind "SUPER + CTRL + Left" "Workspace: switch to previous workspace" (dsp.focusWorkspace "r-1"))
      (bind "SUPER + mouse_down" "Workspace: switch to next existing workspace" (
        dsp.focusWorkspace "e+1"
      ))
      (bind "SUPER + mouse_up" "Workspace: switch to previous existing workspace" (
        dsp.focusWorkspace "e-1"
      ))

      # --- Scratchpad ---
      (bind "SUPER + S" "Scratchpad: show or hide special workspace" (dsp.toggleSpecial "special"))
      (bind "SUPER + SHIFT + S" "Scratchpad: move window to scratchpad and follow" (
        dsp.moveToSpecial "special"
      ))
      (bind "SUPER + ALT + S" "Scratchpad: move window to scratchpad without following" (
        dsp.moveToSpecialSilent "special"
      ))

      # --- Audio ---
      (bindOpts "XF86AudioRaiseVolume" "Audio: increase output volume by 5%"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindOpts "XF86AudioLowerVolume" "Audio: decrease output volume by 5%"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindOpts "XF86AudioMute" "Audio: toggle output mute"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        { locked = true; }
      )

      # --- Media ---
      (bindOpts "XF86AudioPlay" "Media: play or pause playback"
        (dsp.exec "${pkgs.playerctl}/bin/playerctl play-pause")
        { locked = true; }
      )
      (bindOpts "XF86AudioNext" "Media: skip to next track"
        (dsp.exec "${pkgs.playerctl}/bin/playerctl next")
        {
          locked = true;
        }
      )
      (bindOpts "XF86AudioPrev" "Media: return to previous track"
        (dsp.exec "${pkgs.playerctl}/bin/playerctl previous")
        { locked = true; }
      )
      (bindOpts "XF86AudioStop" "Media: stop playback" (dsp.exec "${pkgs.playerctl}/bin/playerctl stop") {
        locked = true;
      })

      # --- Display ---
      (bindOpts "XF86MonBrightnessUp" "Display: increase screen brightness by 10%"
        (dsp.exec "${pkgs.brightnessctl}/bin/brightnessctl set +10%")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindOpts "XF86MonBrightnessDown" "Display: decrease screen brightness by 10%"
        (dsp.exec "${pkgs.brightnessctl}/bin/brightnessctl set 10%-")
        {
          locked = true;
          repeating = true;
        }
      )
    ]
    ++ workspaceBinds;
  };
}
