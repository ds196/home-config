{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    colcon
    (
      with rosPackages.humble;
      buildEnv {
        paths = [
          ros-base
          xacro
          ament-cmake-core
          python-cmake-module
          ros2-control
          control-msgs
          robot-state-publisher
          rmw-cyclonedds-cpp
          zed-msgs
        ];
      }
    )
    # I put a list in your set in list in set
    (lib.hiPrio (
      pkgs.python313.withPackages (
        ps: with ps; [
          pyserial
          pygame
          scipy
          crccheck
        ]
      )
    ))
  ];
}
