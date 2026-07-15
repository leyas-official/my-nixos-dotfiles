{
  description = "Home Manager config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./nixos/configuration.nix

            home-manager.nixosModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit spicetify-nix;
                };

                users.leyas = {
                  imports = [
                    ./home.nix
                    spicetify-nix.homeManagerModules.default
                  ];
                };

              };
            }
          ];
        };
      };

    };
}
