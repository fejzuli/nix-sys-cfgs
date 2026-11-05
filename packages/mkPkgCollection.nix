{ buildEnv, lib }:

name: args:
buildEnv {
  inherit name;
  paths = lib.attrValues (
    lib.removeAttrs args [
      "mkPkgCollection"
      "lib"
    ]
  );
}
