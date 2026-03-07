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
    ])
    ++ (with pkgs.python313Packages; [
      pylatexenc
    ]);
}
