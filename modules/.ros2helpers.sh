# ROS2 Helper Functions and Aliases
# Prepared by David Sharpe
# Started ~6/18/25
# Updated 3/6/26
#####################################################################


FILENAME=".ros2helpers.sh"

UBUNTU_VER=$(command -v lsb_release >/dev/null 2>&1 && lsb_release -cs 2>/dev/null)
ROS_DISTRO=humble  # Default to Humble if not on Ubuntu
[ "$UBUNTU_VER" = "jammy" ] && export ROS_DISTRO=humble
[ "$UBUNTU_VER" = "noble" ] && export ROS_DISTRO=jazzy

CURR_SHELL=$(ps -cp "$$" -o command="")

# Command completions
if command -v register-python-argcomplete >/dev/null 2>&1; then
    eval "$(register-python-argcomplete ros2)"
    eval "$(register-python-argcomplete colcon)"
fi


# Source main ROS2 underlay
if command -v ros2 >/dev/null 2>&1; then
    if [ -d "/opt/ros/$ROS_DISTRO" ]; then
    	source /opt/ros/$ROS_DISTRO/setup.$CURR_SHELL
    else
    	if [ -d /opt/ros -a -z $(ls /opt/ros 2>/dev/null) ]; then
    		echo "[$FILENAME] Available ROS distros: $(ls /opt/ros)"
    	fi
    fi
fi

# Verify that $1 is a valid ROS workspace
verify_ws() {
	# Use PWD by default
    DIR=${1:-$PWD}

	# Make sure this is a ros2 workspace
	if [ ! -d "$DIR" -o $(basename "$DIR") = "src" -o ! -d "$DIR/src" -o "$DIR" = "$HOME" ]; then
		echo "[$FILENAME] Error: Are you sure this is a ROS2 workspace? $DIR"
		return 1;
	fi
}

# Build a workspace. Mainly just here to keep the flags in one spot.
# This is an alias for adding addl. flags
alias buildws='/usr/bin/env colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'

# Change directories into $1, build if required, and source setup
start_ws() {
	# Use PWD by default
    DIR=${1:-$PWD}

	if ! (verify_ws "$DIR"); then
		return 1;
	fi

	if [[ "$PWD" != "$DIR" ]]; then
        cd $DIR
    fi
    #echo "PATH: $PATH"
    #echo "COLCON_PREFIX_PATH: $COLCON_PREFIX_PATH"
    #echo "colcon: $(which colcon)"

	if [ ! -f "./install/setup.$CURR_SHELL" ]; then
        buildws
    fi
    sourcews
}

# Just source a workspace. Just source it. Includes sourced workspaces when building.
function sourcews {
    if [ ! -f "./install/setup.$CURR_SHELL" ]; then
        return 1;
    fi
    source "install/setup.$CURR_SHELL"
}


# Just source, but build if needed
alias sw='start_ws'
# Build and source
alias bs='verify_ws $PWD && buildws && sourcews'
alias cbs='verify_ws $PWD && rm -rf build/ install/ || bs'

