class Memcached < DebianFormula
  homepage 'http://memcached.org/'
  url "http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz"
  sha1 '12ec84011f408846250a462ab9e8e967a2e8cbbc'

  name 'memcached'
  version '1.4.15'
  section 'web'
  description 'A high-performance memory object caching system'

  build_depends 'libevent-dev'

  config_files \
    '/etc/default/memcached',
    '/etc/init.d/memcached'

  def build
    configure :prefix => prefix, :disable_coverage => true
    make
  end

  def install
    super

    (etc/'init.d').install_p(workdir/'init.d', 'memcached')

    (share/'memcached').install 'scripts'
    (share/'memcached').install workdir/'memcached.conf.default'
    (share/'doc/memcached').install Dir['doc/*.txt']
  end
end
