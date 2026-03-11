{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      nixfmt-rfc-style
      zsh-nix-shell
      xclip
      ripgrep
      fd
      silver-searcher
      trash-cli
      bat
      rsync
      gnutar
      curl
      lsb-release
      tmux
      nh
    ]);
}
