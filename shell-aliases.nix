{ pkgs, lib, ... }:
{
  programs.zsh.shellAliases = {
    "rm" = "trash-put";
    "rmdir" = "trash-put";
    "cat" = "bat";
    "ls" =
      "eza --across --icons=auto --hyperlink --header --smart-group --mounts --git --git-repos-no-status --color=auto -h";

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
}
