{
  description = "Download/Setup toolchains from bootlin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "toolchain_ctl";
      version = "0.0.1";
      src = ./.;
      dontPatchShebangs = true;
      installPhase = ''
        mkdir -p $out/bin
        cp toolchain_ctl $out/bin/toolchain_ctl
        cp .env $out/bin/.env
        chmod +x $out/bin/toolchain_ctl
      '';
    };
  };
}

