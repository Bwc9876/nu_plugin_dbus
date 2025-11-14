{
  description = "Nushell Plugin DBUS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flakelight.url = "github:nix-community/flakelight";
    flakelight.inputs.nixpkgs.follows = "nixpkgs";
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flakelight
    , crane
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
        , pkgs
        ,
        }:
        let
          craneLib = crane.mkLib pkgs;
          src = ./.;
          commonArgs = {
            inherit src;
            strictDeps = true;
            nativeBuildInputs = [
              pkg-config
            ];
            buildInputs = [
              dbus
            ];
          };
          cargoArtifacts = craneLib.buildDepsOnly commonArgs;
          nu_plugin_dbus = craneLib.buildPackage (
            commonArgs
            // {
              inherit cargoArtifacts;
            }
          );
          nu_version = "0.108.0";
        in
        if nushell.version == nu_version then
          nu_plugin_dbus
        else
          abort "Nushell Version mismatch\nPlugin: ${nu_version}\tnixpkgs: ${nushell.version}";

    };
}
