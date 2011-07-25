require 'formula'

class Collectd < DebianFormula
  url 'http://collectd.org/files/collectd-5.0.0.tar.bz2'
  homepage 'http://collectd.org/'
  md5 '7bfea6e82d35b36f16d1da2c71397213'

  name 'collectd'
  section 'utils'
  version '5.0.0+github1'
  description 'statistics collection and monitoring daemon'

  config_files '/etc/collectd/collectd.conf'

  def build
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--with-python=/usr/bin",
            "--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--sysconfdir=/etc/collectd"]

    system "./configure", *args
    system "make"
  end

  def install
    super
    (etc/'init.d').install_p(workdir/'init.d', 'collectd')
    (prefix/'lib/perl/5.10.0/perllocal.pod').unlink
  end
end
