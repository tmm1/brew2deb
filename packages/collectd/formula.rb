class Collectd < DebianFormula
  homepage 'http://collectd.org/'
  url 'http://collectd.org/files/collectd-5.0.0.tar.bz2'
  md5 '7bfea6e82d35b36f16d1da2c71397213'

  name 'collectd'
  section 'utils'
  version '5.0.0+github1'
  description 'statistics collection and monitoring daemon'

  build_depends \
    'python-dev',
    'libmysqlclient15-dev'

  depends \
    'python',
    'libmysqlclient15off'

  config_files '/etc/collectd/collectd.conf'

  def build
    configure \
      '--disable-debug',
      '--with-python=/usr/bin',
      '--prefix=/usr',
      '--localstatedir=/var',
      '--sysconfdir=/etc/collectd'

    make
  end

  def install
    super
    (etc/'init.d').install_p(workdir/'init.d', 'collectd')
    (prefix/'lib/perl/5.10.0/perllocal.pod').unlink
  end
end
