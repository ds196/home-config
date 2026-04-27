{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/shell-arch.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/syncthing.nix
    ./modules/tmux.nix
    ./modules/zsh-experience.nix
    ./modules/packages
    ./modules/packages/base-extra.nix
    ./modules/packages/graphical.nix
    ./modules/packages/ros2-extra.nix
  ];

  home.packages = with pkgs; [
    texliveSmall
    pandoc
    lynx
    tio
    pre-commit
  ];
  ros2.extraPythonPackages = ps: with ps; [
    pylatexenc
    typer
  ];

  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = true;

  home = {
    # My laptop -- david@d2framework
    username = "david";
    homeDirectory = "/home/david";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
