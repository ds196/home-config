{ pkgs, ... }:
{
  home.packages = with pkgs; [
    logisim-evolution
    zed-editor-fhs
  ];
}
