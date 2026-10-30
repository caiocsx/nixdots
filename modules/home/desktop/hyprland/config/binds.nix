{
  config,
  lib,
  pkgs,
  ...
}:
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
    cycleLayout = lua ''
      function()
        local layouts = { "scrolling", "dwindle", "master", "monocle" }
        local workspace = hl.get_active_workspace()
        local specialWorkspace = hl.get_active_special_workspace()

        if specialWorkspace then
          workspace = specialWorkspace
        end

        if not workspace then
          return
        end

        local nextLayout = "dwindle"

        for i, layout in ipairs(layouts) do
          if layout == workspace.tiled_layout then
            nextLayout = layouts[(i % #layouts) + 1]
            break
          end
        end

        local workspaceSelector = workspace.special and workspace.name or workspace.id
        hl.workspace_rule({ workspace = tostring(workspaceSelector), layout = nextLayout })
      end
    '';
    toggleLowDistractionMode = lua ''
      function()
        if hl.get_config("animations.enabled") == false then
          hl.exec_cmd("hyprctl reload")
          return
        end

        hl.config({
          general = {
            border_size = 0,
          },
          animations = {
            enabled = false,
          },
          decoration = {
            active_opacity = 1;
            inactive_opacity = 0.98;
            shadow = { enabled = false },
            blur = { enabled = false },
          },
        })
      end
    '';
    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
    moveToSpecialSilent =
      name: lua ''hl.dsp.window.move({ workspace = "special:${name}", follow = false })'';
    moveFromSpecial = lua ''
      function()
        local workspace = hl.get_active_workspace()
        if not workspace then
          return
        end

        hl.dispatch(hl.dsp.window.move({ workspace = workspace.id }))
      end
    '';
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
    (bind "SUPER + ${toString i}" "Workspaces: Switch to workspace ${toString i}" (
      dsp.focusWorkspace i
    ))
    (bind "SUPER + SHIFT + ${toString i}"
      "Workspaces: Move window to workspace ${toString i} and follow"
      (dsp.moveToWorkspace i)
    )
    (bind "SUPER + ALT + ${toString i}"
      "Workspaces: Move window to workspace ${toString i} without following"
      (dsp.moveToWorkspaceSilent i)
    )
  ]) (lib.range 1 9);
in
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # --- Applications ---
      (bind "SUPER + Return" "Applications: Launch terminal" (dsp.app apps.terminal))
      (bind "SUPER + SPACE" "Applications: Toggle app launcher" (dsp.exec "vicinae vicinae://toggle"))
      (bind "SUPER + E" "Applications: Launch file manager" (dsp.app apps.fileManager))
      (bind "SUPER + B" "Applications: Launch web browser" (dsp.app apps.browser))
      (bind "SUPER + D" "Applications: Launch code editor" (dsp.app apps.editor))

      # --- Utilities ---
      (bind "SUPER + period" "Utilities: Search emoji and symbols" (
        dsp.exec "vicinae vicinae://launch/core/search-emojis"
      ))
      (bind "SUPER + ALT + K" "Utilities: Search Hyprland keybinds" (
        dsp.exec "vicinae 'vicinae://launch/@sovereign/vicinae-extension-hypr-keybinds-0/hyprland-keybinds'"
      ))
      (bind "SUPER + SHIFT + C" "Utilities: Pick screen color and copy it" (
        dsp.exec "hyprpicker --autocopy"
      ))

      # --- Connectivity ---
      (bind "SUPER + ALT + N" "Connectivity: Open Wi-Fi controls" (dsp.app "${apps.terminal} -e wlctl"))
      (bind "SUPER + ALT + B" "Connectivity: Open Bluetooth controls" (
        dsp.app "${apps.terminal} -e bluetui"
      ))

      # --- System ---
      (bind "SUPER + X" "System: Toggle Waybar visibility" (
        dsp.exec "${pkgs.systemd}/bin/systemctl --user kill --signal=SIGUSR1 --kill-whom=main waybar.service"
      ))
      (bind "SUPER + ESCAPE" "System: Open power menu" (dsp.exec "vicinae vicinae://launch/power"))
      (bind "SUPER + CTRL + L" "System: Lock screen" (dsp.exec "hyprlock"))
      (bindOpts "XF86Sleep" "System: Suspend computer" (dsp.exec "${pkgs.systemd}/bin/systemctl suspend")
        { locked = true; }
      )
      (bind "SUPER + ALT + M" "System: Open system monitor" (
        dsp.app "${apps.terminal} -e ${apps.systemMonitor}"
      ))

      # --- Notifications ---
      (bind "SUPER + A" "Notifications: Toggle notification center" (
        dsp.exec "swaync-client --toggle-panel --skip-wait"
      ))
      (bind "SUPER + SHIFT + A" "Notifications: Dismiss all notifications" (
        dsp.exec "swaync-client --close-all --skip-wait"
      ))
      (bind "SUPER + CTRL + A" "Notifications: Toggle do not disturb" (
        dsp.exec "swaync-client --toggle-dnd --skip-wait"
      ))

      # --- Wallpaper ---
      (bind "SUPER + W" "Wallpaper: Open wallpaper picker" (
        dsp.exec "vicinae 'vicinae://launch/@sovereign/vicinae-extension-awww-switcher-0/wpgrid?toggle=true'"
      ))

      # --- Clipboard ---
      (bind "SUPER + V" "Clipboard: Search and copy from history" (
        dsp.exec "vicinae vicinae://launch/clipboard/history"
      ))

      # --- Screenshot ---
      (bind "SUPER + PRINT" "Screenshots: Save region and copy to clipboard" (
        dsp.exec "screenshot --region"
      ))
      (bind "SUPER + SHIFT + PRINT" "Screenshots: Save window and copy to clipboard" (
        dsp.exec "screenshot --window"
      ))
      (bind "SUPER + CTRL + PRINT" "Screenshots: Save monitor and copy to clipboard" (
        dsp.exec "screenshot --output"
      ))
      (bind "SUPER + SHIFT + F12" "Screenshots: Save region after 5 seconds" (
        dsp.exec "screenshot --region --delay 5"
      ))

      # --- Visuals ---
      (bind "SUPER + ALT + T" "Visuals: Toggle low-distraction mode" dsp.toggleLowDistractionMode)

      # --- Window ---
      (bind "SUPER + M" "Windows: Toggle maximized state" dsp.maximize)
      (bind "SUPER + Q" "Windows: Close active window" dsp.close)
      (bind "SUPER + SHIFT + Q" "Windows: Force close active window" dsp.kill)
      (bind "SUPER + F" "Windows: Toggle floating mode" dsp.float)
      (bind "SUPER + SHIFT + F" "Windows: Toggle floating mode and center at 760x440" (
        dsp.floatSized 760 440
      ))

      # --- Layout ---
      (bind "SUPER + ALT + L" "Layouts: Cycle workspace layout" dsp.cycleLayout)
      (bind "SUPER + P" "Layouts: Toggle pseudo tiling" dsp.pseudo)
      (bind "SUPER + T" "Layouts: Toggle split orientation" (dsp.layout "togglesplit"))
      (bind "SUPER + bracketleft" "Layouts: Decrease split ratio" (dsp.layout "splitratio -0.05"))
      (bind "SUPER + bracketright" "Layouts: Increase split ratio" (dsp.layout "splitratio +0.05"))

      # --- Window / Focus ---
      (bind "SUPER + L" "Windows: Focus window to the right" (dsp.focus "right"))
      (bind "SUPER + H" "Windows: Focus window to the left" (dsp.focus "left"))
      (bind "SUPER + K" "Windows: Focus window above" (dsp.focus "up"))
      (bind "SUPER + J" "Windows: Focus window below" (dsp.focus "down"))

      # --- Window / Move ---
      (bind "SUPER + SHIFT + L" "Windows: Swap with window to the right" (dsp.swap "right"))
      (bind "SUPER + SHIFT + H" "Windows: Swap with window to the left" (dsp.swap "left"))
      (bind "SUPER + SHIFT + K" "Windows: Swap with window above" (dsp.swap "up"))
      (bind "SUPER + SHIFT + J" "Windows: Swap with window below" (dsp.swap "down"))
      (bindOpts "SUPER + mouse:272" "Windows: Move window with mouse" dsp.drag {
        mouse = true;
      })

      # --- Window / Resize ---
      (bindOpts "SUPER + ALT + Right" "Windows: Increase width" (dsp.resizeActive 30 0) {
        repeating = true;
      })
      (bindOpts "SUPER + ALT + Left" "Windows: Decrease width" (dsp.resizeActive (-30) 0) {
        repeating = true;
      })
      (bindOpts "SUPER + ALT + Up" "Windows: Decrease height" (dsp.resizeActive 0 (-30)) {
        repeating = true;
      })
      (bindOpts "SUPER + ALT + Down" "Windows: Increase height" (dsp.resizeActive 0 30) {
        repeating = true;
      })
      (bindOpts "SUPER + mouse:273" "Windows: Resize window with mouse" dsp.resize {
        mouse = true;
      })

      # --- Workspace ---
      (bind "SUPER + G" "Workspaces: Toggle overview" (lua ''
        function()
          hl.plugin.hyprexpo.expo("toggle")
        end
      ''))
      (bind "SUPER + tab" "Workspaces: Switch to next existing workspace" (dsp.focusWorkspace "e+1"))
      (bind "SUPER + SHIFT + tab" "Workspaces: Switch to previous existing workspace" (
        dsp.focusWorkspace "e-1"
      ))
      (bind "SUPER + CTRL + Right" "Workspaces: Switch to next workspace" (dsp.focusWorkspace "r+1"))
      (bind "SUPER + CTRL + Left" "Workspaces: Switch to previous workspace" (dsp.focusWorkspace "r-1"))
      (bind "SUPER + mouse_down" "Workspaces: Switch to next existing workspace" (
        dsp.focusWorkspace "e+1"
      ))
      (bind "SUPER + mouse_up" "Workspaces: Switch to previous existing workspace" (
        dsp.focusWorkspace "e-1"
      ))

      # --- Scratchpad ---
      (bind "SUPER + S" "Scratchpad: Toggle visibility" (dsp.toggleSpecial "special"))
      (bind "SUPER + SHIFT + S" "Scratchpad: Send focused window to scratchpad and show it" (
        dsp.moveToSpecial "special"
      ))
      (bind "SUPER + ALT + S" "Scratchpad: Send focused window here without switching workspaces" (
        dsp.moveToSpecialSilent "special"
      ))
      (bind "SUPER + CTRL + S" "Scratchpad: Return window to current workspace" (dsp.moveFromSpecial))

      # --- Zoom ---
      (bind "SUPER + ALT + mouse_up" "Zoom: Set screen zoom to 150%" (
        lua "function() hl.config({ cursor = { zoom_factor = 1.5 } }) end"
      ))
      (bind "SUPER + ALT + mouse_down" "Zoom: Reset screen zoom to 100%" (
        lua "function() hl.config({ cursor = { zoom_factor = 1.0 } }) end"
      ))

      # --- Audio ---
      (bind "SUPER + ALT + A" "Audio: Open audio mixer" (dsp.app "${apps.terminal} -e wiremix"))
      (bindOpts "XF86AudioRaiseVolume" "Audio: Increase output volume by 5%"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindOpts "XF86AudioLowerVolume" "Audio: Decrease output volume by 5%"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindOpts "XF86AudioMute" "Audio: Toggle output mute"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        { locked = true; }
      )
      (bindOpts "XF86AudioMicMute" "Audio: Toggle microphone mute"
        (dsp.exec "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
        { locked = true; }
      )

      # --- Media ---
      (bindOpts "XF86AudioPlay" "Media: Toggle playback"
        (dsp.exec "${pkgs.playerctl}/bin/playerctl play-pause")
        { locked = true; }
      )
      (bindOpts "XF86AudioNext" "Media: Play next track" (dsp.exec "${pkgs.playerctl}/bin/playerctl next")
        {
          locked = true;
        }
      )
      (bindOpts "XF86AudioPrev" "Media: Play previous track"
        (dsp.exec "${pkgs.playerctl}/bin/playerctl previous")
        { locked = true; }
      )
      (bindOpts "XF86AudioStop" "Media: Stop playback" (dsp.exec "${pkgs.playerctl}/bin/playerctl stop") {
        locked = true;
      })

      # --- Display ---
      (bindOpts "XF86MonBrightnessUp" "Display: Increase brightness by 10%"
        (dsp.exec "${pkgs.brightnessctl}/bin/brightnessctl set +10%")
        {
          locked = true;
          repeating = true;
        }
      )
      (bindOpts "XF86MonBrightnessDown" "Display: Decrease brightness by 10%"
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
