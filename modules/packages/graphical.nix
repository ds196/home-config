{ pkgs, ... }:
{
  home.packages = with pkgs; [
    logisim-evolution
    zed-editor-fhs
    qtcreator
    android-studio
    alttab
    arduino-ide
    audacity
    blender
    discord
  ];
}
