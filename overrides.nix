{ lock }:

self: super: {
  straightBuild = { pname, ... }@args: self.trivialBuild ({
    sname = pname;
    version = "1";
    src = lock pname;
    buildPhase = ":";
  } // args);

  spicetify-themes = self.straightBuild rec {
    pname = "spicetify-themes";
    version = "f4ab4ecbaa92118ebca690bf0f58ad9da7592dbf";
    installPhase = ''
      mkdir -p $out
      cp -r ./ $out
    '';
  };
}