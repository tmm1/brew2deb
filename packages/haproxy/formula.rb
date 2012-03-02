class Haproxy < DebianFormula
  homepage 'http://haproxy.1wt.eu/'
  url 'http://haproxy.1wt.eu/download/1.4/src/haproxy-1.4.19.tar.gz'
  md5 '41392d738460dbf99295fd928031c6a4'

  name 'haproxy'
  version '1.4.19'
  section 'net'
  description 'The Reliable, High Performance TCP/HTTP Load Balancer'

  build_depends 'libpcre3-dev'

  def build
    make 'TARGET' => 'linux26', 'CPU' => 'native', 'USE_PCRE' => '1', 'PREFIX' => '/usr'
  end

  def install
    make :install, 'DESTDIR' => destdir, 'PREFIX' => '/usr', 'DOCDIR' => '/usr/share/doc'
  end
end
