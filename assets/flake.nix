{
  description = "nixos-unified-template flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstb.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, nixpkgs-unstb, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
     	let
    		pkgs = nixpkgs.legacyPackages.${system};
    		unstb = nixpkgs-unstb.legacyPackages.${system};
     	in {
        devShells.default = pkgs.mkShell {
          NIX_SHELL_NAME="JS";
       	  packages = with pkgs; [
       	    # Packages used to take demo
            vhs
            ffmpeg
            ttyd
            chromium

            # Packages used within demo
            tree
            # # For Copy-Paste 
       	    # xclip
       	    # wl-clipboard
         	];
        };
      }
    );
}
