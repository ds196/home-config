{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    extraConfig = ''
      set number relativenumber
      set scrolloff=3
      set smartcase

      " tabs
      set expandtab
      autocmd FileType * setlocal tabstop=4 shiftwidth=4 softtabstop=4
      autocmd FileType nix setlocal tabstop=2 shiftwidth=2 softtabstop=2

      " cursor
      augroup RestoreCursorShapeOnExit
        autocmd!
        autocmd VimLeave * set guicursor=a:ver20
      augroup END

      " line highlighting
      hi CursorLine cterm=NONE
      hi CursorLineNR cterm=bold
      set cursorline
    '';

    extraLuaConfig = ''
      -- vscode-nvim
      vim.o.background = 'dark'
      local c = require('vscode.colors').get_colors()
      require('vscode').setup({
        transparent = true,
        italic_comments = true,
        disable_nvimtree_bg = true
      })
      vim.cmd.colorscheme "vscode"

      -- snacks-nvim
      require('snacks').setup({
        bigfile = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        scope = { enabled = true },
        quickfile = { enabled = true }
      })

      -- lualine-nvim
      require('lualine').setup({
        options = {
          theme = 'codedark'
        }
      })
    '';

    plugins = with pkgs.vimPlugins; [
      coc-html
      coc-pyright
      coc-sh
      coc-json
      coc-docker
      coc-git
      render-markdown-nvim
      nvim-treesitter.withAllGrammars
      rainbow-delimiters-nvim
      vscode-nvim
      snacks-nvim
      lualine-nvim
    ];

    coc = {
      enable = true;
      settings = {
        languageserver = {
          rust = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            args = [ ];
            rootPatterns = [
              "*.rs"
            ];
            filetypes = [ "rust" ];
          };

          nix = {
            command = "${pkgs.nil}/bin/nil";
            args = [ ];
            filetypes = [ "nix" ];
          };

        };
      };
    };

  };
}
