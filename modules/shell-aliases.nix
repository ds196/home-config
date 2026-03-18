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
    c = # sh
      ''
        	# Compile a c/cpp program
        	# I'm getting tired of accidentally overwriting all of my code
        	if [ -z "$1" ]; then
        		echo "No file provided"
        		echo
        		return 1;
        	fi
        	if [ ! -f "$1" ]; then
        		echo "Error: file not found: $1"
        		echo
        		return 1;
        	fi
        	if [[ "$1" != *.c && "$1" != *.cpp ]]; then
        		echo "Error: requested source file is not a C/CPP source file: $1"
        		echo
        		return 1;
        	fi
        	cp "$1" ".$1.bak"
        	echo "=== Starting compilation. ==="
        	set -x
        	[[ "$1" == *.c ]] && gcc "$1" -o "''${1%.*}" || g++ -Wall -std=c++17 "$1" -o "''${1%.*}"
            CODE=$?
        	set +x
        	echo "=== Compiled ''${1%.*}. ==="
        	echo
            return $CODE;
      '';
      serial = # sh
      ''
        mkdir -p "$HOME/.tio-logs"
        if [ ! -d "$HOME/.tio-logs" ]; then
            return 1;
        fi

        tio -te --map INLCRNL --log --log-directory "$HOME/.tio-logs" "$1"
    '';
  };
}
