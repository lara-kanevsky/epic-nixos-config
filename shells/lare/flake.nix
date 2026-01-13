{
  description = "Flake dev de 0 uwu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          kind
          kubectl
          argocd
        ];

        shellHook = ''
          export KUBECONFIG="$PWD/.kube/config"
          mkdir -p .kube
          echo "Using kubeconfig at $KUBECONFIG"

          alias k="kubectl"
        '';
      };
    };
}
