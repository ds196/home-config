{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.packages =
    (with pkgs; [
      ripgrep
      fd
      jq
      manix
      delta
      vcstool
      valgrind
      p7zip
      htop
      can-utils
      cmd-wrapped
      nmap
    ]);
}
