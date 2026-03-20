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
  ];
  ros2.extraPythonPackages =
    ps: with ps; [
      pyserial
      pygame
      scipy
      crccheck
    ];
}
