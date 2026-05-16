{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./ros2.nix
  ];

  ros2.extraRosPaths = with pkgs.rosPackages.humble; [
    ros2-control
    control-msgs
    robot-state-publisher
    ros2-controllers
    rqt-graph
    rviz2
    rqt-common-plugins
    zed-msgs
    teleop-twist-keyboard
    teleop-twist-joy
    teleop-tools
    mouse-teleop
    plotjuggler
    plotjuggler-ros
    tf2-tools
    # rtsp-image-transport  # Only available for rolling and jazzy
  ];
  ros2.extraPythonPackages =
    ps: with ps; [
      pyserial
      pygame
      scipy
      crccheck
      bpython
      matplotlib
      mypy
      build
    ];
}
