{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }:
    let
      system = "aarch64-linux";
    in
    {
      nixosConfigurations.nixprl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          hostname = "nixprl";
          inherit self;
        };
        modules = [
          disko.nixosModules.disko
          (import "${self}/parallels")
          ./configurations.nix
        ];
      };
    };
}
