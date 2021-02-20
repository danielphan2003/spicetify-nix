{ 
extraPackages ? spkgs: []
, extraConfig ? ""
, spotifyPackages
, dependencyOverrides ? { }
, theme ? "SpicetifyDefault"
, colorScheme ? ""
, thirdParyThemes ? {}
, thirdParyExtensions ? {}
, thirdParyCustomApps ? {}
, enabledExtensions ? []
, enabledCustomApps ? []
, spotifyLaunchFlags ? ""
, injectCss ? false
, replaceColors ? false
, overwriteAssets ? false
, disableSentry ? true
, disableUiLogging ? true
, removeRtlRule ? true
, exposeApis ? true
, disableUpgradeCheck ? true
, fastUserSwitching ? false
, visualizationHighFramerate ? false
, radio ? false
, songPage ? false
, experimentalFeatures ? false
, home ? false
, lyricAlwaysShow ? false
, lyricForceNoSync ? false
, pkgs
, lib
, buildGoModule
, spicetify-cli
}:
let
  inherit (lib.lists) foldr;
  inherit (lib.attrsets) mapAttrsToList;

  flake = import ./flake-compat-helper.nix { src=./.; };
  lock = p: if dependencyOverrides ? ${p}
            then dependencyOverrides.${p}
            else flake.inputs.${p};
  
  overrides = self: super:
    (pkgs.callPackage ./overrides.nix { inherit lock; } self super);

  # Helper functions
  pipeConcat = foldr (a: b: a + "|" + b) "";
  lineBreakConcat = foldr (a: b: a + "\n" + b) "";
  boolToString = x: if x then "1" else "0";
  makeLnCommands = type: (mapAttrsToList (name: path: "ln -sf ${path} ./${type}/${name}"));

  # Setup spicetify
  spicetify-cli-local = "SPICETIFY_CONFIG=. ${spicetify-cli}/bin/spicetify-cli";

  spicetify-themes = stdenv.mkDerivation {
    name = "spicetify-themes";
    src = lock "spicetify-themes";
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';
  };

  # Dribblish is a theme which needs a couple extra settings
  isDribblish = theme == "Dribbblish";
  
  extraCommands = (if isDribblish then "cp ./Themes/Dribbblish/dribbblish.js ./Extensions \n" else "")
    + (lineBreakConcat (makeLnCommands "Themes" thirdParyThemes))
    + (lineBreakConcat (makeLnCommands "Extensions" thirdParyExtensions))
    + (lineBreakConcat (makeLnCommands "CustomApps" thirdParyCustomApps));

  customAppsFixupCommands = lineBreakConcat (makeLnCommands "Apps" thirdParyCustomApps);
  
  injectCssOrDribblish = boolToString (isDribblish || injectCss);
  replaceColorsOrDribblish = boolToString (isDribblish || replaceColors);
  overwriteAssetsOrDribblish = boolToString (isDribblish || overwriteAssets);

  extensionString = pipeConcat ((if isDribblish then [ "dribbblish.js" ] else []) ++ enabledExtensions);
  customAppsString = pipeConcat enabledCustomApps;
in
pkgs.spotify.overrideAttrs (oldAttrs: rec {
  postInstall = ''
    touch $out/prefs
    mkdir Themes
    mkdir Extensions
    mkdir CustomApps

    find ${spicetify-themes} -maxdepth 1 -type d -exec ln -s {} Themes \;
    ${extraCommands}
    
    ${spicetify-cli-local} config \
      spotify_path "$out/share/spotify" \
      prefs_path "$out/prefs" \
      current_theme ${theme} \
      ${if 
          colorScheme != ""
        then 
          ''color_scheme "${colorScheme}" \'' 
        else 
          ''\'' }
      ${if 
          extensionString != ""
        then 
          ''extensions "${extensionString}" \'' 
        else 
          ''\'' }
      ${if
          customAppsString != ""
        then 
          ''custom_apps "${customAppsString}" \'' 
        else 
          ''\'' }
      ${if
          spotifyLaunchFlags != ""
        then 
          ''spotify_launch_flags "${spotifyLaunchFlags}" \'' 
        else 
          ''\'' }
      inject_css ${injectCssOrDribblish} \
      replace_colors ${replaceColorsOrDribblish} \
      overwrite_assets ${overwriteAssetsOrDribblish} \
      disable_sentry ${boolToString disableSentry } \
      disable_ui_logging ${boolToString disableUiLogging } \
      remove_rtl_rule ${boolToString removeRtlRule } \
      expose_apis ${boolToString exposeApis } \
      disable_upgrade_check ${boolToString disableUpgradeCheck } \
      fastUser_switching ${boolToString fastUserSwitching } \
      visualization_high_framerate ${boolToString visualizationHighFramerate } \
      radio ${boolToString radio } \
      song_page ${boolToString songPage } \
      experimental_features ${boolToString experimentalFeatures } \
      home ${boolToString home } \
      lyric_always_show ${boolToString lyricAlwaysShow } \
      lyric_force_no_sync ${boolToString lyricForceNoSync }

    ${spicetify-cli-local} backup apply

    cd $out/share/spotify
    ${customAppsFixupCommands}
  '';
})
