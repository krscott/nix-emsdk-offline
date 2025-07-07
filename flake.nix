{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    emsdk-src.url = "github:emscripten-core/emsdk?ref=4.0.9";
    emsdk-src.flake = false;
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    emsdk-src,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = {
          default = self.packages.${system}.emsdk-offline;
          emsdk-offline = pkgs.callPackage ./. {inherit emsdk-src;};

          install-emsdk-offline = pkgs.writeShellScriptBin "install-emsdk-offline" ''
            # Copy emsdk files to current directory

            dest="''${1:-''${PWD:-.}/emsdk}"

            if [ -e "$dest" ]; then
              echo "'$dest' already exists" 2>&1
            fi

            cp -r "${self.packages.${system}.emsdk-offline}/share/emsdk" "$dest"
            chmod u+rwX -R "$dest"
          '';

          install-emscripten-cache = pkgs.writeShellScriptBin "install-emscripten-cache" ''
            # Copy emscripten cache to current directory

            dest="''${1:-''${PWD:-.}/.emscripten-cache}"

            if [ -e "$dest" ]; then
              echo "'$dest' already exists" 2>&1
            fi

            cp -r ${pkgs.emscripten}/share/emscripten/cache/ "$dest"
            chmod u+rwX -R "$dest"

            # Only works if this script was `source`d
            export EM_CACHE="$dest"
          '';
        };

        formatter = pkgs.alejandra;
      }
    );
}
