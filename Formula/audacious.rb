class Audacious < Formula
  desc "Free and advanced audio player based on GTK+"
  homepage "https://audacious-media-player.org/"
  revision 1

  stable do
    url "https://distfiles.audacious-media-player.org/audacious-3.10.1.tar.bz2"
    sha256 "8366e840bb3c9448c2cf0cf9a0800155b0bd7cc212a28ba44990c3d2289c6b93"

    resource "plugins" do
      url "https://distfiles.audacious-media-player.org/audacious-plugins-3.10.1.tar.bz2"
      sha256 "eec3177631f99729bf0e94223b627406cc648c70e6646e35613c7b55040a2642"
    end
  end

  bottle do
    sha256 "866912eb7c8e29e0e2a415bbdf20e8edfc3bbfd96aed0216548948c9e8294d69" => :catalina
    sha256 "286ac8c7614d1768c8fb3322391207be3fd0fe336bae107ffb453acae8048223" => :mojave
    sha256 "1f484b5cbe7d900e5037c6ac4669d9783436d800e2018c8ad52dff69282a24f6" => :high_sierra
  end

  head do
    url "https://github.com/audacious-media-player/audacious.git"

    resource "plugins" do
      url "https://github.com/audacious-media-player/audacious-plugins.git"
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "glib"
  depends_on "lame"
  depends_on "libbs2b"
  depends_on "libcue"
  depends_on "libnotify"
  depends_on "libsamplerate"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "neon"
  depends_on "qt"
  depends_on "sdl2"
  depends_on "wavpack"
  uses_from_macos "python@2"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-coreaudio
      --disable-gtk
      --disable-mpris2
      --enable-mac-media-keys
      --enable-qt
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    resource("plugins").stage do
      ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"

      system "./autogen.sh" if build.head?

      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    audtool does not work due to a broken dbus implementation on macOS, so is not built
    coreaudio output has been disabled as it does not work (Fails to set audio unit input property.)
    GTK+ gui is not built by default as the QT gui has better integration with macOS, and when built, the gtk gui takes precedence
  EOS
  end

  test do
    system bin/"audacious", "--help"
  end
end
