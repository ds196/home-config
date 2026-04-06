{ pkgs, lib, ... }:
{
  programs.tmux.enable = true;

  programs.tmux = {
    clock24 = true;
    historyLimit = 5000;
    mouse = true;
    secureSocket = false;

    #extraConfig = # tmux
    #  ''
    #    set -g @tmux_power_theme 'moon'
    #    set -g @tmux_power_left_d ""
    #    set -g @tmux_power_right_w ""
    #    set -g @tmux_power_right_x ""
    #  '';

    plugins = with pkgs; [
      #tmuxPlugins.tmux-powerline
      tmuxPlugins.resurrect
    ];

    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
  };
}
