{ pkgs, lib, config, ... }:
{
  options.ros2 = {
    extraRosPaths = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };
    extraPythonPackages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = ps: [];
    };
  };

  config.home.packages = with pkgs; [
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
        ] ++ config.ros2.extraRosPaths;
      }
    )
    # I put a list in your set in list in set
    (lib.hiPrio (
      pkgs.python313.withPackages (
        ps: (with ps; [
          pyserial
          pygame
          scipy
          crccheck
        ]
      ) ++ config.ros2.extraPythonPackages ps)
    ))
  ];
}
