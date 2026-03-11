{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/zsh-experience.nix
    ./modules/arch-shell.nix
    ./modules/neovim.nix
    ./modules/packages
    ./modules/packages/graphical.nix
  ];
  home.packages = with pkgs; [
    texliveSmall
    pandoc
    lynx
  ];
  ros2.extraRosPaths = with pkgs.rosPackages.humble; [
    ros2-controllers
    rqt-graph
    rviz2
  ];
  ros2.extraPythonPackages = ps: with ps; [ pylatexenc ];

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
