let

  pkgs = import <nixpkgs> { overlays = [ (import
        (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    cargo
    rust-analyzer
    rust-bin.stable.latest.default
  ];
}
