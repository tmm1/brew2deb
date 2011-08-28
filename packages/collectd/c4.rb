class C4 < DebianFormula
  url 'git://git.verplant.org/collection4.git'
  homepage 'http://octo.it/c4/'

  arch 'all'
  name 'collection4'
  version '4.0.0+git20110827'
  description 'web-based front-end for collectd'

  build_depends 'libfcgi-dev', 'librrd-dev', 'yajl'
  depends 'libfcgi0ldbl', 'yajl', 'spawn-fcgi'

  def build
    sh './autogen.sh'
    configure :sysconfdir => '/etc', :prefix => prefix
    make
  end

  def install
    super
    (etc/'init.d').install_p(workdir/'init.d-c4', 'collection4')
    (etc/'nginx/sites-available').install_p(workdir/'nginx-c4', 'collection4')
  end
end
