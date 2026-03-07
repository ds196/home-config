{ pkgs, lib, ... }:
{
  programs.zsh.shellAliases = {
    "rm" = "trash-put";
    "rmdir" = "trash-put";
    "cat" = "bat";
    "ls" =
      "eza --across --icons=auto --hyperlink --header --smart-group --mounts --git --git-repos-no-status --color=auto -h";
    "la" = "ls -a";
    "ll" = "ls -l";
    "lla" = "ls -lla";
    "lt" = "ls --tree";

    "cprult" = "rsync --info=progress2 -auvAUU";
    "untar" = "tar -xvf";
    "sha" = "shasum -a 256";

    "fwsetup" = "systemctl reboot --firmware-setup";
    "myip" = "curl ipinfo.io/ip";
    "setup_vcan" = "sudo ip link add dev vcan0 type vcan && sudo ip link set vcan0 up";

    "sl" = "ls";
    ":q" = "exit";
    "nixgl" = "nixGLIntel";
  };

  programs.zsh.siteFunctions = {
    md = ''
      pandoc "''${1:-README.md}" | lynx -stdin
    '';
    led_off = ''
      ros2 topic pub --once /anchor/relay std_msgs/String "{data: 'led_set,0,0,0\n'}"
    '';
  };
}
