{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./modules/zsh-experience.nix
    ./modules/neovim.nix
    ./modules/packages/base.nix
    ./modules/tmux.nix
  ];
  home.packages = (
    with pkgs;
    [
      nix-direnv
      git
      openssh
      ncdu
    ]
  );

  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = false;


  home = {
    # Blackhawk -- ds0196@blackhawk.ece.uah.edu
    username = "ds0196";
    homeDirectory = "/home/student/ds0196";

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
