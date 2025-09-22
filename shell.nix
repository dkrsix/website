let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { overlays = [ (import sources.rust-overlay) ]; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    cargo
    rust-analyzer
    rust-bin.stable.latest.default
  ];
}
