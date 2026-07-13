{
  description = "Home Manager config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    helium.url = "github:FKouhai/helium2nix/main";
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      spicetify-nix,
      helium,
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
                  inherit spicetify-nix helium;
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
