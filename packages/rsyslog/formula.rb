class Rsyslog < DebianFormula
  homepage 'http://www.rsyslog.com'
  url 'http://www.rsyslog.com/files/download/rsyslog/rsyslog-5.10.1.tar.gz'
  sha256 '2f643a2c613d5b09f242affd32a90cf4fb7a9ac4557dc80f218e6f3e5affb4c8'

  name 'rsyslog'
  version '5.10.1'
  description 'enhanced multi-threaded syslogd'

  build_depends \
    'zlib1g-dev'

  config_files \
    '/etc/rsyslog.conf',
    '/etc/default/rsyslog',
    '/etc/logrotate.d/rsyslog',
    '/etc/logcheck/ignore.d.server/rsyslog'

  def install
    super

    etc.install_p workdir/'rsyslog.conf'
    (etc/'default').install_p workdir/'default', 'rsyslog'
    (etc/'logrotate.d').install_p workdir/'logrotate', 'rsyslog'
    (etc/'init.d').install_p workdir/'init.d', 'rsyslog'
  end
end
