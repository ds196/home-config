{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      nixfmt-rfc-style
      xclip
      trash-cli
      bat
      rsync
      gnutar
      curl
      lsb-release
      nh
      silver-searcher
      fzf
      btop
    ]);
}
