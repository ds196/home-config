{ pkgs, lib, ... }:
{
  programs.tmux.enable = true;

  programs.tmux = {
    clock24 = true;
    historyLimit = 5000;
    mouse = true;

    plugins = with pkgs; [
      tmuxPlugins.cpu
    ];

    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
  };
}
