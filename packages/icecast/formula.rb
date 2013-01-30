require 'formula'

class Icecast < DebianFormula
  homepage 'http://www.icecast.org/'
  url 'http://downloads.xiph.org/releases/icecast/icecast-2.3.3.tar.gz'
  sha1 '61cf1bd5b4ed491aad488dc6cf1ca2d8eb657363'

  name 'icecast'
  version '2.3.3'
  description 'stream oggvorbis for github.fm'

  depends 'libvorbis0a', 'libvorbis-dev', 'libogg0', 'libogg-dev'
  #depends 'pkg-config', 'speex', 'libogg', 'theora', 'libvorbis'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    (prefix+'var/log/icecast').mkpath
    touch prefix+'var/log/icecast/error.log'
  end
end
