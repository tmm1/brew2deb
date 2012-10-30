class Memcached < DebianFormula
  homepage 'http://memcached.org/'
  url "http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz"
  sha1 '12ec84011f408846250a462ab9e8e967a2e8cbbc'

  name 'memcached'
  version '1.4.15'
  section 'web'
  description 'A high-performance memory object caching system'

  build_depends 'libevent-dev'

  def build
    configure :prefix => prefix, :disable_coverage => true
    make
  end
end
