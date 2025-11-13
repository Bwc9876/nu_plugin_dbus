{
  description = "Nushell Plugin DBUS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flakelight.url = "github:nix-community/flakelight";
    flakelight.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs @ { self
    , nixpkgs
    , flakelight
    ,
    }:
    flakelight ./. {
      inherit inputs;
      pname = "nu_plugin_dbus";
      package =
        { rustPlatform
        , dbus
        , nushell
        , pkg-config
        , fetchFromGitHub
        , lib
        ,
        }:
        rustPlatform.buildRustPackage rec {
          pname = "nu_plugin_dbus";
          version =
            if nushell.version == nu_version
            then "0.20.0"
            else abort "Nushell Version mismatch\nPlugin: ${nu_version}\tnixpkgs: ${nushell.version}";
          nu_version = "0.108.0";

          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;

          nativeBuildInputs = [
            pkg-config
          ];

          buildInputs = [
            dbus
          ];

          meta = with lib; {
            description = "A nushell plugin for interacting with dbus";
            license = licenses.mit;
            mainProgram = "nu_plugin_dbus";
            homepage = "https://github.com/devyn/nu_plugin_dbus";
          };
        };
    };
}
