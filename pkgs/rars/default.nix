{ lib, stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  pname = "rars";
  version = "lastest";

  src = fetchurl {
    url = "https://github.com/rarsm/rars/releases/download/${version}/rars-flatlaf.jar";
    hash = "sha256-qHcjqSpDhOSZSauh9scxkJknPRUnk3NnObSEiswIdCY=";
  };

  buildInputs = [ jre ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm644 ${src} $out/share/java/rars.jar
    echo "#!/bin/sh" > $out/bin/rars
    echo "exec ${jre}/bin/java -jar $out/share/java/rars.jar \"\$@\"" >> $out/bin/rars
    chmod +x $out/bin/rars
  '';

  meta = with lib; {
    description = "RARS -- RISC-V Assembler and Runtime Simulator";
    homepage = "https://github.com/rarsm/rars";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
