{ pkgs, lib, ... }:
{
  programs.zsh.shellAliases = {
    "pacin" = "sudo pacman -S";
    "startfocal" = "sudo ~/scripts/tschroot.sh ~/myfocal";
    "startjammy" = "sudo ~/scripts/tschroot.sh /mnt/Ubuntu22";
    "startnoble" = "sudo ~/scripts/tschroot.sh /mnt/Ubuntu24";
    "nord" = "sudo systemctl start nordvpnd && nordvpn connect us";
  };
  programs.zsh.siteFunctions = {
    launch_camara = ''
      if [ -z "''${1}" ]; then
        echo "Please add a number for the camera"
	return 1;
      fi
      echo "Opening camera: 192.168.1.''${1}."

      gst-launch-1.0 -v playbin uri="rtsp://192.168.1.''${1}:554/user=admin&password=&channel=1&stream=0.sdp?" uridecodebin0::source::latency=0
    '';
  };

}
