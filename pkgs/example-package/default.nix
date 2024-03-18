{ stdenv
, fetchurl
, autoPatchelfHook
, makeWrapper
, lib
, callPackage
, ...
} @ args:

################################################################################
# Mostly based on dingtalk-bin package from AUR:
# https://aur.archlinux.org/packages/sunloginclient
################################################################################

stdenv.mkDerivation rec {
  pname = "sunloginclient";
  version = "1.4.0.20425";
  src = fetchurl {
    url = "https://d.oray.com/sunlogin/linux/SunloginClient_15.2.0.63062_amd64.deb";
    sha256 = "sha256-FlQTN/aVMNgSCWJqvm0aS4OUZA9Ltb5i8VGLH0pEdG0=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  unpackPhase = ''
    ar x ${src}
    tar xf data.tar.xz

    rm -rf release/Resources/{i18n/tool/*.exe,qss/mac}
    rm -f release/{*.a,*.la,*.prl}
    rm -f release/dingtalk_updater
    rm -f release/libgtk-x11-2.0.so.*
    rm -f release/libm.so.*
  '';

  installPhase = ''
    mkdir -p $out
    mv version $out/

    mv release $out/lib

    # 这里的 desktop 文件和图标是从 AUR 拿的
    mkdir -p $out/share/applications $out/share/pixmaps
  '';
}
