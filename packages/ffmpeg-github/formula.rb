class FfmpegGitHub < DebianFormula
  name 'ffmpeg-github'
  url 'http://ffmpeg.org/releases/ffmpeg-1.1.2.tar.bz2'
  sha1 '1fb1c2019ff13440b3670dc83846c654b245c4c9'
  homepage 'http://ffmpeg.org/'

  version "1.1.2-github1"
  description "ffmpeg turns one thing into another thing"

  depends "lame-github"
  build_depends "lame-github"

  def build
    system "./configure", "--enable-libmp3lame",
                          "--enable-nonfree",
                          "--enable-pthreads",
                          "--enable-openssl",
                          "--prefix=#{prefix}"
  end

  def install
    system "make install"
  end
end
