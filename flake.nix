{

description = "My first flake";
inputs = {
	nixpkgs.url = "nixpkgs/nixos-24.11";
	home-manager.url = "github:nix-community/home-manager/release-24.11";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
	swww.url = "github:LGFae/swww";
	xremap-flake.url = "github:xremap/nix-flake";
	hyprpanel.url = "github:Jas-SinghFSU/Hyprpanel";
};
outputs = { self, nixpkgs, home-manager, ...}@inputs:
	let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
	in {
		nixosConfigurations = {
			machine = lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [ ./configuration.nix 
					{nixpkgs.overlays = [inputs.hyprpanel.overlay];}
				];
			};
		};
		homeConfigurations = {
			admin = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [ ./home.nix ];
			};
		};
	};
}
