{
  description = "";
  nixConfig.bash-prompt = "[dkr6.com] $ ";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      
    in
    {
      devShells.x86_64-linux.default = pkgs.haskellPackages.developPackage {
        root = ./.;
        modifier = drv: pkgs.haskell.lib.addBuildTool drv (with pkgs.haskellPackages; [
          haskell-language-server
          cabal-install
        ]);
      };
      packages.x86_64-linux.default = pkgs.haskellPackages.developPackage {
        root = ./.;
      };
    };
}
