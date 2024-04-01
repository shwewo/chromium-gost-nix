{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, flac
, gnome2
, harfbuzzFull
, nss
, snappy
, xdg-utils
, xorg
, alsa-lib
, atk
, cairo
, cups
, curl
, dbus
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk3
, libX11
, libxcb
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libdrm
, libnotify
, libopus
, libpulseaudio
, libuuid
, libxshmfence
, mesa
, nspr
, pango
, systemd
, at-spi2-atk
, at-spi2-core
, libqt5pas
, qt6
, vivaldi-ffmpeg-codecs
}:

stdenv.mkDerivation rec {
  pname = "chromium-gost";
  version = "123.0.6312.86";

  src = fetchurl {
    url = "https://github.com/deemru/Chromium-Gost/releases/download/${version}/chromium-gost-${version}-linux-amd64.deb";
    sha256 = "sha256-MRtBThsUaGJ25htkqeunOO4ftLT2g3QZTtr7NIitxdc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    qt6.wrapQtAppsHook
    wrapGAppsHook
  ];

  buildInputs = [
    flac
    harfbuzzFull
    nss
    snappy
    xdg-utils
    xorg.libxkbfile
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    fontconfig.lib
    freetype
    gdk-pixbuf
    glib
    gnome2.GConf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libdrm
    libnotify
    libopus
    libuuid
    libxcb
    libxshmfence
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    libqt5pas
    qt6.qtbase
  ];
 
  unpackPhase = ''
    mkdir -p $out/bin $out/share/ $out/opt $TMP
    mkdir -p $out/share/icons/hicolor/128x128/apps/
    mkdir -p $out/share/icons/hicolor/256x256/apps/
    mkdir -p $out/share/icons/hicolor/32x32/apps/
    mkdir -p $out/share/icons/hicolor/16x16/apps/
    mkdir -p $out/share/icons/hicolor/24x24/apps/
    mkdir -p $out/share/icons/hicolor/48x48/apps/
    ar vx $src
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/
    ls $TMP
  '';

  installPhase = ''
    cp -r $TMP/opt/ $out/
    cp -r $TMP/usr/share $out/
    substituteInPlace $out/share/applications/${pname}.desktop --replace /usr/ $out/
    substituteInPlace $out/share/gnome-control-center/default-apps/${pname}.xml --replace /opt/ $out/opt/
    ln -sf ${vivaldi-ffmpeg-codecs}/lib/libffmpeg.so $out/opt/${pname}/libffmpeg.so
    ln -sf $out/opt/${pname}/${pname} $out/bin/${pname}
    ln -s $out/opt/${pname}/product_logo_128.png $out/share/icons/hicolor/128x128/apps/${pname}.png
    ln -s $out/opt/${pname}/product_logo_256.png $out/share/icons/hicolor/256x256/apps/${pname}.png
    ln -s $out/opt/${pname}/product_logo_32.png $out/share/icons/hicolor/32x32/apps/${pname}.png
    ln -s $out/opt/${pname}/product_logo_16.png $out/share/icons/hicolor/16x16/apps/${pname}.png
    ln -s $out/opt/${pname}/product_logo_24.png $out/share/icons/hicolor/24x24/apps/${pname}.png
    ln -s $out/opt/${pname}/product_logo_48.png $out/share/icons/hicolor/48x48/apps/${pname}.png
  '';

  runtimeDependencies = map lib.getLib [
    libpulseaudio
    curl
    systemd
    vivaldi-ffmpeg-codecs
  ] ++ buildInputs;

  meta = with lib; {
    description = "Chromium with GOST encryption support";
    homepage = "https://cryptopro.ru/products/chromium-gost";
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ];
    mainProgram = "chromium-gost";
    platforms = [ "x86_64-linux" ];
  };
}
