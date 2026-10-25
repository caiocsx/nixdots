{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";
    # Core editor behavior.
    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;
      undofile = true;
      swapfile = false;
    };
    # Clipboard and diagnostic display.
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    diagnostic.settings = {
      virtual_text = true;
      severity_sort = true;
      float = {
        border = "rounded";
        source = "if_many";
      };
    };
    plugins = {
      # Interface and dashboard.
      web-devicons.enable = true;
      lualine.enable = true;
      indent-blankline.enable = true;
      illuminate.enable = true;
      nui.enable = true;
      notify.enable = true;
      noice.enable = false;
      alpha = {
        enable = true;
        theme = "dashboard";
      };
      # File navigation and search.
      telescope.enable = true;
      oil = {
        enable = true;
        settings = {
          view_options.show_hidden = true;
          watch_for_changes = true;
        };
      };
      # Editing helpers.
      which-key.enable = true;
      nvim-autopairs.enable = true;
      # Syntax highlighting and parsing.
      treesitter = {
        enable = true;
        highlight.enable = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash
          css
          html
          javascript
          json
          lua
          nix
          rust
          tsx
          typescript
          toml
          yaml
        ];
      };
      # Completion and snippets.
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "default";
            "<CR>" = [
              "accept"
              "fallback"
            ];
            "<Tab>" = [
              "select_next"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "fallback"
            ];
          };
          appearance.nerd_font_variant = "mono";
          completion.documentation = {
            auto_show = true;
            auto_show_delay_ms = 500;
          };
          signature.enabled = true;
        };
      };
      luasnip.enable = true;
      friendly-snippets.enable = true;
      # Language servers and LSP keymaps.
      lsp = {
        enable = true;
        keymaps = {
          lspBuf = {
            "gd" = "definition";
            "gri" = "implementation";
            "grr" = "references";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
          diagnostic = {
            "<leader>dl" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
        servers = {
          bashls = {
            enable = true;
            package = null;
          };
          lua_ls = {
            enable = true;
            package = null;
          };
          nixd = {
            enable = true;
            package = null;
          };
          rust_analyzer = {
            enable = true;
            package = null;
            installCargo = false;
            installRustc = false;
            installRustfmt = false;
          };
          ts_ls = {
            enable = true;
            package = null;
          };
        };
      };
      # Git signs and diff review.
      gitsigns.enable = true;
      diffview.enable = true;
      # Code formatting.
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            bash = [ "shfmt" ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            rust = [ "rustfmt" ];
            sh = [ "shfmt" ];
            javascript = [ "biome" ];
            javascriptreact = [ "biome" ];
            typescript = [ "biome" ];
            typescriptreact = [ "biome" ];
            json = [ "biome" ];
            css = [ "biome" ];
          };
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
        };
      };
      # Integrated terminal.
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<c-/>]]";
          direction = "vertical";
          size.__raw = ''
            function()
              return math.max(1, math.floor(vim.o.columns * 0.40))
            end
          '';
          persist_size = false;
        };
      };
    };
    # Keymaps grouped by feature.
    keymaps = [
      # File navigation and search.
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<CR>";
        options.desc = "Open File Explorer (Oil)";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Find Text";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<CR>";
        options.desc = "Help Tags";
      }
      # Formatting and search behavior.
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format({ async = true })<CR>";
        options.desc = "Format Code";
      }
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear Search Highlight";
      }
      # Window and terminal navigation.
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-h>";
        action = "<cmd>wincmd h<CR>";
        options.desc = "Focus Left Window";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-j>";
        action = "<cmd>wincmd j<CR>";
        options.desc = "Focus Lower Window";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-k>";
        action = "<cmd>wincmd k<CR>";
        options.desc = "Focus Upper Window";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-l>";
        action = "<cmd>wincmd l<CR>";
        options.desc = "Focus Right Window";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-Right>";
        action = "<cmd>vertical resize -5<CR>";
        options.desc = "Decrease Window Width";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-Left>";
        action = "<cmd>vertical resize +5<CR>";
        options.desc = "Increase Window Width";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-Up>";
        action = "<cmd>resize +3<CR>";
        options.desc = "Increase Window Height";
      }
      {
        mode = [
          "n"
          "t"
        ];
        key = "<A-Down>";
        action = "<cmd>resize -3<CR>";
        options.desc = "Decrease Window Height";
      }
      # Git diff review.
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>DiffviewOpen<CR>";
        options.desc = "Open Git diff";
      }
      {
        mode = "n";
        key = "<leader>gD";
        action = "<cmd>DiffviewClose<CR>";
        options.desc = "Close Diffview";
      }
      {
        mode = "n";
        key = "<leader>gh";
        action = "<cmd>DiffviewFileHistory %<CR>";
        options.desc = "Show current file Git history";
      }
    ];
    # Alpha dashboard layout, dynamic information, and button actions.
    extraConfigLua = ''
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "                                    ██████                                    ",
        "                                ████▒▒▒▒▒▒████                                ",
        "                              ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                              ",
        "                            ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                            ",
        "                          ██▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒                              ",
        "                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▓▓▓▓                          ",
        "                          ██▒▒▒▒▒▒  ▒▒▓▓▒▒▒▒▒▒  ▒▒▓▓                          ",
        "                        ██▒▒▒▒▒▒▒▒▒▒    ▒▒▒▒▒▒▒▒    ██                        ",
        "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
        "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
        "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
        "                        ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██                        ",
        "                        ██▒▒██▒▒▒▒▒▒██▒▒▒▒▒▒▒▒██▒▒▒▒██                        ",
        "                        ████  ██▒▒██  ██▒▒▒▒██  ██▒▒██                        ",
        "                        ██      ██      ████      ████                        ",
      }
      dashboard.section.header.opts = { hl = "Normal", position = "center" }

      dashboard.section.buttons.val = {
        dashboard.button("n", "󰻭 New file", "<cmd>enew<CR>"),
        dashboard.button("f", "󰱽 Find files", "<cmd>Telescope find_files<CR>"),
        dashboard.button("g", "󱎸 Find Text", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("r", "󰋚 Recents", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("e", "󰷏 Explore", "<cmd>Oil<CR>"),
        dashboard.button("q", "󰈆 Quit", "<cmd>qa<CR>"),
      }
      dashboard.section.buttons.opts.spacing = 1

      local function dashboard_info()
        local date = " 󰸘  " .. os.date("Today is %a %d %b")

        local plugin_count = 0
        for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
          if path:match("/pack/[^/]+/start/[^/]+$") then
            plugin_count = plugin_count + 1
          end
        end

        local plugins = " 󰏖  " .. plugin_count .. " plugins in total"

        local date_width = vim.fn.strdisplaywidth(date)
        local plugins_width = vim.fn.strdisplaywidth(plugins)
        local width = math.max(date_width + 1, plugins_width)

        local top = "╭─"
          .. date
          .. " "
          .. string.rep("─", width - date_width)
          .. "╮"

        local bottom = "╰─"
          .. plugins
          .. string.rep(" ", width - plugins_width)
          .. "─╯"

        return { top, bottom }
      end

      local info = {
        type = "text",
        val = dashboard_info,
        opts = { hl = "Keyword", position = "center" },
      }

      dashboard.section.footer.val = "Keep learning, keep building."
      dashboard.section.footer.opts = { hl = "Keyword", position = "center" }
      local layout = {
        {
          type = "group",
          opts = { position = "v_center", spacing = 1 },
          val = {
            dashboard.section.header,
            { type = "padding", val = 2 },
            info,
            { type = "padding", val = 2 },
            dashboard.section.buttons,
            { type = "padding", val = 2 },
            dashboard.section.footer,
          },
        },
      }
      alpha.setup({
        layout = layout,
        opts = { margin = 5 },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          vim.opt_local.foldenable = false
        end,
      })
    '';
  };
}
