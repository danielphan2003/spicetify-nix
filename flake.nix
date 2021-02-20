{
  description = "spicetify-nix home-manager module";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    spicetify-cli.url = "github:khanhas/spicetify-cli";
    spicetify-cli.flake = false;
    spicetify-themes.url = "github:morpheusthewhite/spicetify-themes";
    spicetify-themes.flake = false;
  };

  outputs = { nixpkgs, flake-utils, ... }@inputs:
    let
      inherit (flake-utils.lib) eachDefaultSystem eachSystem;
    in
    eachDefaultSystem
      (system: { }) //
    eachSystem [ "x86_64-linux" "x86-linux" "aarch64-linux" ]
      (system: { }) //
    {
      hmModule = import ./modules/home-manager.nix inputs;
    };
}