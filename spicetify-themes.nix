{ stdenv, fetchFromGitHub }:
let version = "a4af565";
in
stdenv.mkDerivation {
  pname = "spicetify-themes";
  inherit version;

  src = fetchFromGitHub {
    owner = "morpheusthewhite";
    repo = "spicetify-themes";
    rev = "a4af565eb32ccf665a51c11ff79616a1cabad9ec";
    sha256 = "sha256-WdDjKlIUkygN23G/y1AfnLk6eNDeL+kr8dS+Gicncoc=";
    fetchSubmodules = true;
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out
    cp -r ./ $out
  '';
 
  meta = with stdenv.lib; {
    description = "A community-driven collection of themes for Spicetify";
    homepage = "https://github.com/morpheusthewhite/spicetify-themes";
    maintainers = with maintainers; [ pietdevries94 danielphan2003 ];
    license = licenses.mit;
    inherit version;
  };
}
