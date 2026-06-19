{
  description = "Home Manager config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      spicetify-nix,
      ...
    }:
    let
      pkgs = import nixpkgs {
        localSystem = "x86_64-linux";
      };
    in
    {
      homeConfigurations."leyas" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit spicetify-nix;
        };
        modules = [
          ./home.nix
          spicetify-nix.homeManagerModules.default
        ];
      };
    };
}
