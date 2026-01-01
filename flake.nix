{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = github:nix-community/home-manager;
  };
  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.antonietacookstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ./home-manager.nix];
    };
  };
}