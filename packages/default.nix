{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
}:

let
  files = lib.removeAttrs (lib.readDir ./.) [ "default.nix" ];
  mapFiles = fn: lib.mapAttrs' fn files;
  withScope = fn: lib.makeScope pkgs.newScope fn;
  cleanUp =
    attrs:
    lib.removeAttrs attrs [
      "callPackage"
      "mkPkgCollection"
      "newScope"
      "overrideScope"
      "packages"
    ];
in
cleanUp (
  withScope (
    scope:
    mapFiles (
      name: type:
      if type == "directory" then
        {
          inherit name;
          value = scope.callPackage (./. + "/${name}/package.nix") { };
        }
      else if type == "regular" && lib.hasSuffix ".nix" name then
        {
          name = lib.removeSuffix ".nix" name;
          value = scope.callPackage (./. + "/${name}") { };
        }
      else
        throw "Non nix file ${name}"
    )
  )
)
