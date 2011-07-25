class Credis < DebianFormula
  homepage 'http://code.google.com/p/credis/'
  url 'http://credis.googlecode.com/files/credis-0.2.3.tar.gz'
  md5 '338c21667ece272d9ab669738e27b191'

  name 'libcredis'
  section 'devel'
  version '0.2.3+github1'
  description 'C client library for redis'

  def build
    make
  end

  def install
    ['libcredis.a', 'libcredis.so'].each do |f|
      lib.install f
    end
    include.install 'credis.h'
    doc.install 'README'
  end
end
