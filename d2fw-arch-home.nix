{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./shell.nix
    ./arch-shell.nix
    ./editor.nix
    ./packages
    ./packages/graphical.nix
  ];
  home.packages = with pkgs; [
    texliveSmall
    pandoc
    lynx
    (
      with rosPackages.humble;
      buildEnv {
        paths = [
          ros2-controllers
          rqt-graph
          rviz2
        ];
      }
    )
    # I put a list in your set in list in set
    (lib.hiPrio (
      pkgs.python313.withPackages (
        ps: with ps; [
          pylatexenc
        ]
      )
    ))
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
