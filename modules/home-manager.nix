{ self, ... }@inputs:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.spicetify;
  inherit (lib) literalExample mkEnableOption mkIf mkOption types;
  overlayType = lib.mkOptionType {
    name = "overlay";
    description = "Spicetify packages overlay";
    check = lib.isFunction;
    merge = lib.mergeOneOption;
  };
in {
  options.programs.spicetify = {
    enable = mkEnableOption "A modded Spotify";
    extraConfig = mkOption {
      description = ''
        Extra configuration options to pass to spicetify-cli.
        Elisp code set here will be appended at the end of `config.el`. This
        option is useful for refering `nixpkgs` derivation in Emacs without the
        need to install them globally.
      '';
      type = with types; lines;
      default = "";
      example = literalExample ''
        (setq mu4e-mu-binary = "''${pkgs.mu}/bin/mu")
      '';
    };
    spotifyPackage = mkOption {
      description = ''
        Spotify package to use.
        Override this if you want to use a custom spotify derivation to base
        `spicetify-nix` on.
      '';
      type = with types; package;
      default = pkgs.spotify;
      example = literalExample "pkgs.spotifywm";
    };
    extraPackages = mkOption {
      description = ''
        Extra packages to install.
        List addition packages here that improve Spotify functionalities.
      '';
      type = with types; listOf package;
      default = [ ];
      example = literalExample "[ pkgs.spotifyd ]";
    };
    theme = mkOption {
      type = with types; str;
      default = "SpicetifyDefault";
    };
    colorScheme = mkOption {
      type = with types; str;
      default = "";
    };
    thirdParyThemes = mkOption {
      type = with types; attrs;
      default = {};
    };
    thirdParyExtensions = mkOption {
      type = with types; attrs;
      default = {};
    };
    thirdParyCustomApps = mkOption {
      type = with types; attrs;
      default = {};
    };
    enabledExtensions = mkOption {
      type = with types; listOf str;
      default = [];
    };
    enabledCustomApps = mkOption {
      type = with types; listOf str;
      default = [];
    };
    spotifyLaunchFlags = mkOption {
      type = with types; str;
      default = "";
    };
    injectCss = mkOption {
      type = with types; bool;
      default = false;
    };
    replaceColors = mkOption {
      type = with types; bool;
      default = false;
    };
    overwriteAssets = mkOption {
      type = with types; bool;
      default = false;
    };
    disableSentry = mkOption {
      type = with types; bool;
      default = true;
    };
    disableUiLogging = mkOption {
      type = with types; bool;
      default = true;
    };
    removeRtlRule = mkOption {
      type = with types; bool;
      default = true;
    };
    exposeApis = mkOption {
      type = with types; bool;
      default = true;
    };
    disableUpgradeCheck = mkOption {
      type = with types; bool;
      default = true;
    };
    fastUserSwitching = mkOption {
      type = with types; bool;
      default = false;
    };
    visualizationHighFramerate = mkOption {
      type = with types; bool;
      default = false;
    };
    radio = mkOption {
      type = with types; bool;
      default = false;
    };
    songPage = mkOption {
      type = with types; bool;
      default = false;
    };
    experimentalFeatures = mkOption {
      type = with types; bool;
      default = false;
    };
    home = mkOption {
      type = with types; bool;
      default = false;
    };
    lyricAlwaysShow = mkOption {
      type = with types; bool;
      default = false;
    };
    lyricForceNoSync = mkOption {
      type = with types; bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (
    let spicetify = pkgs.callPackage self {
      extraPackages = (spkgs: cfg.extraPackages);
      dependencyOverrides = inputs;
      inherit (cfg) 
        theme
        colorScheme
        thirdParyThemes
        thirdParyExtensions
        thirdParyCustomApps
        enabledExtensions
        enabledCustomApps
        spotifyLaunchFlags
        injectCss
        replaceColors
        overwriteAssets
        disableSentry
        disableUiLogging
        removeRtlRule
        exposeApis
        disableUpgradeCheck
        fastUserSwitching
        visualizationHighFramerate
        radio
        songPage
        experimentalFeatures
        home
        lyricAlwaysShow
        lyricForceNoSync;
    };
    in 
    {
      home.packages = [
        spicetify
      ];
    }
  );
}