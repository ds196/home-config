{
  description = "Home Manager configuration of ds0196";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/develop";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-ros-overlay,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix-ros-overlay.overlays.default ];
      };
    in
    {
      homeConfigurations."david" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./d2fw-arch-home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
      homeConfigurations."ds0196" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./blackhawk-home.nix ];
        extraSpecialArgs = { inherit inputs; };
      };
    };

  nixConfig = {
    # Cache to pull ros packages from
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };
}
