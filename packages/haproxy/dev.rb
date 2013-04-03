class HAProxy < DebianFormula
  homepage 'http://haproxy.1wt.eu/'
  url 'http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev18.tar.gz'
  md5 '39c2cc3ccef059794377d557aef2fa43'

  name 'haproxy'
  version '1.5-dev18+github1'
  section 'net'
  description 'The Reliable, High Performance TCP/HTTP Load Balancer'

  build_depends ['libpcre3-dev','libssl-dev','zlib1g-dev']

  depends 'libssl0.9.8'

  config_files '/etc/haproxy/haproxy.cfg'
  requires_user 'haproxy', :remove => false

  def build
    make  'TARGET'       => 'linux2628',
          'CPU'          => 'native',
          'PREFIX'       => '/usr',
          'USE_CTTPROXY' => '1',
          'USE_PCRE'     => '1',
          'USE_OPENSSL'  => '1',
          'USE_ZLIB'     => '1'
  end

  def install
    make :install,
      'DESTDIR' => destdir,
      'PREFIX'  => '/usr',
      'DOCDIR'  => '/usr/share/doc/haproxy'

    (etc/'haproxy').install_p 'examples/haproxy.cfg'
    (etc/'haproxy').install_p 'examples/errorfiles/', 'errors'
    (etc/'default').install_p workdir/'default-haproxy', 'haproxy'
    (etc/'init.d').install_p  workdir/'init.d-haproxy',  'haproxy'
  end
end
