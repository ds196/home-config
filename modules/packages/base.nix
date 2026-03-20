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
      tmux
      nh
      silver-searcher
      fzf
    ]);
}
