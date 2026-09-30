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
    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      splitright = true;
      splitbelow = true;
      undofile = true;
    };
    clipboard = {
      register = "unnamedplus";
      providers.wl-copy.enable = true;
    };
    plugins = {
      telescope.enable = true;
      web-devicons.enable = true;
      lualine.enable = true;
      gitsigns.enable = true;
      which-key.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          bash
          json
          lua
          markdown
          markdown_inline
          nix
          vim
          vimdoc
          yaml
        ];
        settings.highlight.enable = true;
      };
      blink-cmp = {
        enable = true;
        settings.keymap.preset = "default";
      };
      lsp = {
        enable = true;
        servers.nil_ls.enable = true;
      };
      conform-nvim = {
        enable = true;
        settings.formatters_by_ft.nix = [ "nixfmt" ];
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
        options.desc = "Clear search highlight";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Search text";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find buffers";
      }
      {
        mode = "n";
        key = "gd";
        action.__raw = "vim.lsp.buf.definition";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action.__raw = "vim.lsp.buf.rename";
        options.desc = "Rename symbol";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Code action";
      }
      {
        mode = "n";
        key = "<leader>f";
        action.__raw = "function() require('conform').format({ async = true, lsp_format = 'fallback' }) end";
        options.desc = "Format buffer";
      }
    ];
  };
}
