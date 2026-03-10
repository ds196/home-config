{ config, pkgs, ... }:
{
  programs.neovim.enable = true;

  programs.neovim = {
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    extraConfig = # vim
      ''
        set number relativenumber
        set scrolloff=3
        set smartcase

        " undo
        silent !mkdir -p $HOME/.cache/vim-undo
        set undodir=~/.cache/vim-undo
        set undofile

        " coc
        set updatetime=300
        set signcolumn=yes

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

    extraLuaConfig = # lua
      ''
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

        -- treesitter
        vim.api.nvim_create_autocmd('FileType', {
          pattern = '*',
          callback = function()
            vim.wo[0][0].foldmethod = 'expr'
            vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo[0][0].foldlevel = 99  -- start with all folds open
          end,
        })
      '';

    plugins = with pkgs.vimPlugins; [
      coc-html
      coc-pyright
      coc-sh
      coc-json
      coc-docker
      coc-git
      coc-lua
      coc-vimlsp
      coc-clangd
      render-markdown-nvim
      nvim-treesitter.withAllGrammars
      hmts-nvim
      rainbow-delimiters-nvim
      vscode-nvim
      snacks-nvim
      lualine-nvim
    ];

    coc = {
      enable = true;
      settings = {
        "suggest.noselect" = true;

        "suggest.completionItemKindLabels" = {
          "function" = "󰊕";
          "variable" = "";
          "class" = "";
        };

        # clangd for C/C++
        clangd = {
          path = "${pkgs.clang-tools}/bin/clangd";
          arguments = [
            "--background-index"
            "--clang-tidy"
            "--header-insertion=iwyu"
            "--completion-style=detailed"
            "--function-arg-placeholders"
          ];
        };

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
            command = "${pkgs.nixd}/bin/nixd";
            filetypes = [ "nix" ];
            settings.nixd = {
              formatting.command = [ "${pkgs.nixfmt-rfc-style}/bin/nixfmt" ];
              # Point nixd at your flake for accurate option completions
              options.home-manager.expr = "(builtins.getFlake \"${config.home.homeDirectory}/.config/home-manager\").homeConfigurations.USER.options";
            };
          };

          lua = {
            command = "${pkgs.lua-language-server}/bin/lua-language-server";
            filetypes = [ "lua" ];
            settings.Lua = {
              runtime.version = "LuaJIT"; # Neovim uses LuaJIT
              workspace = {
                library = [ "\${3rd}/luv/library" ];
                checkThirdParty = false;
              };
              diagnostics.globals = [ "vim" ]; # suppress "undefined global vim"
              telemetry.enable = false;
            };
          };

        };
      };
    };

  };
}
