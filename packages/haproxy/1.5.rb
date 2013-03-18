class Haproxy < DebianFormula
  homepage 'http://haproxy.1wt.eu/'
  url 'http://haproxy.1wt.eu/download/1.5/src/devel/haproxy-1.5-dev17.tar.gz'
  md5 'b8deab9989e6b9925410b0bc44dd4353'

  name 'haproxy'
  version '1.5.dev17+github2'
  section 'net'
  description 'The Reliable, High Performance TCP/HTTP Load Balancer'

  build_depends 'libpcre3-dev'
  build_depends 'libssl-dev'

  depends 'libssl0.9.8'

  config_files '/etc/haproxy/haproxy.cfg'
  requires_user 'haproxy', :remove => false

  def build
    make 'TARGET' => 'linux26', 'CPU' => 'native', 'USE_PCRE' => '1', 'USE_OPENSSL' => '1', 'PREFIX' => '/usr'
  end

  def install
    make :install, 'DESTDIR' => destdir, 'PREFIX' => '/usr', 'DOCDIR' => '/usr/share/doc/haproxy'

    (etc/'haproxy').install_p 'examples/haproxy.cfg'
    (etc/'haproxy').install_p 'examples/errorfiles/', 'errors'
    (etc/'default').install_p workdir/'default-haproxy', 'haproxy'
    (etc/'init.d').install_p  workdir/'init.d-haproxy',  'haproxy'
  end
end
