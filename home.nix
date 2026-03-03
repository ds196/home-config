{ inputs, config, pkgs, ... }:

{

  nixpkgs.overlays = [ inputs.nixgl.overlay ];

  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraConfig = ''
      set number

      " cursor
      augroup RestoreCursorShapeOnExit
        autocmd!
	autocmd VimLeave * set guicursor=a:ver20
      augroup END
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


  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh.plugins = [
      pkgs.zsh-nix-shell
    ];
  };
  home.sessionVariables = {
    HYPHEN_INSENSITIVE = "true";
  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    colors = "auto";
    icons = "auto";
  };
  

  home.packages =
    (with pkgs; [
      colcon
      nixfmt-rfc-style
      nixgl.nixGLIntel
      #nixgl.nixGLNvidia  # shi no work
      (
        with rosPackages.humble;
        buildEnv {
          paths = [
            #desktop
            ros-base
            xacro
            ament-cmake-core
            python-cmake-module
            ros2-control
            ros2-controllers
            control-msgs
            robot-state-publisher
	    rqt-graph
          ];
        }
      )
    ])
    ++ (with pkgs.python313Packages; [
      pyserial
      pygame
      scipy
      crccheck
      black
    ]);

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ds0196";
  home.homeDirectory = "/home/student/ds0196";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
