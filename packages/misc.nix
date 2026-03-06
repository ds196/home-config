{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      nixfmt-rfc-style
      zsh-nix-shell
      direnv
      nix-direnv
      xclip
      ripgrep
      fd
      silver-searcher
      texliveSmall
    ])
    ++ (with pkgs.python313Packages; [
      pylatexenc
    ]);
}
