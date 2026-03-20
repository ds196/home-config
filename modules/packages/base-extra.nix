{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      nixfmt-rfc-style
      xclip
      ripgrep
      fd
      silver-searcher
      fzf
      trash-cli
      bat
      rsync
      gnutar
      curl
      lsb-release
      tmux
      nh
      jq
      manix
      delta
    ]);
}
