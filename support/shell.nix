{ pkgs ? import <nixpkgs> {} }:

let
  cosmocc = pkgs.stdenv.mkDerivation rec {
    pname = "cosmocc";
    version = "4.0.2";
    
    src = pkgs.fetchurl {
      url = "https://github.com/jart/cosmopolitan/releases/download/${version}/cosmocc-${version}.zip";
      sha256 = "0i1zxnn0hlm5j5g63f9nnk0p9r3ckyz19v6ld9jjx1kd81xc7f45";
    };
    
    nativeBuildInputs = with pkgs; [ unzip ];
    
    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;
    dontStrip = true;
    dontPatchELF = true;
    dontPatchShebangs = true;
    
    unpackPhase = ''
      mkdir -p $out
      cd $out
      unzip $src
    '';
    
    installPhase = ''
      chmod -R +x $out/bin
    '';
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    gcc
    gnumake
    curl
    scdoc
    pandoc
    mandoc
    pkg-config
    asciinema
    asciinema-agg
    butler
    valgrind
    bubblewrap
  ];

  shellHook = ''
    export PATH=$PATH:${cosmocc}/bin
    echo "minicoder development environment"
  '';
}