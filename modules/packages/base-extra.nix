{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      ripgrep
      fd
      jq
      manix
      delta
      vcstool
      valgrind
    ]);
}
