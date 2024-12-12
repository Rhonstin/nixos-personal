{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgs-unstable, ... }: 
    let
     system = "x86_64-linux";
     pkgs = import nixpkgs { inherit system; }; 
     pkgsUnstable = import nixpkgs-unstable { inherit system; };
    in 
    {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; 
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.devops = import ./home-manager/home.nix;
	        }
        ];
    };
 };
}
