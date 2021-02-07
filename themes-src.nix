{ stdenv, fetchFromGitHub }:
let version = "fdadc4c";
in
stdenv.mkDerivation {
  pname = "spicetify-themes";
  inherit version;

  srcs = pkgs.fetchFromGitHub {
    owner = "morpheusthewhite";
    repo = "spicetify-themes";
    rev = "fdadc4c1cfe38ecd22cf828d2c825e0af1dcda9f";
    sha256 = "1k44g8rmf8bh4kk16w4n9z1502ag3w67ad3jx28327ykq8pq5w29";
    fetchSubmodules = true;
  }

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out
    cp -r ./ $out
  '';
 
  meta = with stdenv.lib; {
    description = "A community-driven collection of themes for Spicetify ";
    homepage = "https://github.com/morpheusthewhite/spicetify-themes";
    maintainers = [ maintainers.danielphan2003 ];
    platforms = platforms.unix;
    license = licenses.mit;
    inherit version;
  };
}
