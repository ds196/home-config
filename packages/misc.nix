{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      nixfmt-rfc-style
      zsh-nix-shell
      direnv
      xclip
      ripgrep
      fd
      silver-searcher
      texliveSmall
      trash-cli
      bat
      rsync
      gnutar
      curl
      pandoc
      lynx
      lsb-release
    ])
    ++ (with pkgs.python313Packages; [
      pylatexenc
    ]);
}
