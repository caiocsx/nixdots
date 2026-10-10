{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";
    extraPackages = with pkgs; [
      nixfmt
      rustfmt
      shfmt
      stylua
    ];
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
      iskeyword = "@,48-57,_,192-255,-";
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;
      undofile = true;
      swapfile = false;
    };
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
      oil.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      nvim-autopairs.enable = true;
      blink-cmp.enable = true;
      treesitter = {
        enable = true;
        highlight.enable = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash
          lua
          nix
          rust
        ];
      };
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
          diagnostic."gl" = "open_float";
        };
        servers = {
          bashls.enable = true;
          lua_ls.enable = true;
          nixd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
        };
      };
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 500;
          };
          formatters_by_ft = {
            bash = [ "shfmt" ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            rust = [ "rustfmt" ];
            sh = [ "shfmt" ];
          };
        };
      };
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
    keymaps = [
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
    ];
  };
}
