{ inputs, config, pkgs, ... }:

{

  nixpkgs.overlays = [ inputs.nixgl.overlay ];

  programs.neovim = {
    enable = true;

    extraConfig = ''
      set number
    '';

    extraLuaConfig = ''
      vim.o.background = 'dark'
      local c = require('vscode.colors').get_colors()
      require('vscode').setup({
        transparent = true,
	italic_comments = true,
	disable_nvimtree_bg = true
      })
      vim.cmd.colorscheme "vscode"
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
  home.username = "david";
  home.homeDirectory = "/home/david";

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
