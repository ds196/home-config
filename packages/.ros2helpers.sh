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

# Just source, but build if needed
alias sw='start_ws'  # This is now a circular dependency. This could never go wrong.
# Build and source
alias bs='verify_ws $PWD && buildws && sw'
alias cbs='verify_ws $PWD && rm -rf build/ install/ || bs'


# Source main ROS2 underlay
if [ -d "/opt/ros/$ROS_DISTRO" ]; then
	source /opt/ros/$ROS_DISTRO/setup.$CURR_SHELL
else
	if [ -d /opt/ros -a -z $(ls /opt/ros 2>/dev/null) ]; then
		echo "[$FILENAME] Available ROS distros: $(ls /opt/ros)"
	fi
fi

# Verify that $1 is a valid ROS workspace
verify_ws() {
	# Use PWD by default
	[ -z "$1" ] && DIR="$PWD" || DIR="$1"

	# Make sure this is a ros2 workspace
	if [ ! -d "$DIR" -o $(basename "$DIR") = "src" -o ! -d "$DIR/src" -o "$DIR" = "$HOME" ]; then
		echo "[$FILENAME] Error: Are you sure this is a ROS2 workspace? $DIR"
		return 1;
	fi
}

# Change directories into $1, build if required, and source setup
start_ws() {
	# Use PWD by default
	[ -z "$1" ] && DIR="$PWD" || DIR="$1"

	if ! (verify_ws "$DIR"); then
		return 1;
	fi

	cd $DIR

	[ -f ./install/setup.$CURR_SHELL ] && source ./install/setup.$CURR_SHELL || bs
}

# Build a workspace. Mainly just here to keep the flags in one spot.
# This is an alias for adding addl. flags
alias buildws='colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'

