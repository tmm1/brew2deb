class Taglib < DebianFormula
  name "taglib"
  url 'https://github.com/downloads/taglib/taglib/taglib-1.8.tar.gz'
  sha1 'bdbfd746fde42401d3a77cd930c7802d374a692d'

  version '1.8'
  description "id3 tag reading and writing"

  build_depends 'cmake'

  def build
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "make"
  end

end