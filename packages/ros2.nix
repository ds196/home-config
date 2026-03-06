{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      colcon
      (
        with rosPackages.humble;
        buildEnv {
          paths = [
            #desktop
            ros-base
            xacro
            ament-cmake-core
            python-cmake-module
            ros2-control
            ros2-controllers
            control-msgs
            robot-state-publisher
            rqt-graph
          ];
        }
      )
    ])
    ++ (with pkgs.python313Packages; [
      pyserial
      pygame
      scipy
      crccheck
    ]);
}
