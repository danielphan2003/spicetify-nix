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
    sha256 = "1k44g8rmf8bh4kk16w4n9z1502ag3w67ad3jx28327ykq8pq5w29";
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
