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
    'libmysqlclient15-dev',
    'libcurl4-openssl-dev',
    'pkg-config',
    'libdbi0-dev',
    'libesmtp-dev',
    'libgcrypt11-dev',
    'libiptcdata0-dev',
    'libmemcached-dev',
    'libsnmp-dev',
    'libopenipmi-dev',
    'liboping-dev',
    'libpcap0.8-dev',
    'libperl-dev',
    'librrd-dev',
    'libyajl-dev',
    'linux-headers-2.6.26-2-common',
    'libcredis'

  depends \
    'python',
    'libmysqlclient15off',
    'libcurl3',
    'libdbi0',
    'libesmtp5',
    'libgcrypt11',
    'libiptcdata0',
    'libmemcached3',
    'libsnmp15',
    'libopenipmi0',
    'liboping0',
    'libpcap0.8',
    'libperl5.10',
    'librrd4',
    'libyajl1',
    'libcredis'

  config_files '/etc/collectd/collectd.conf'

  def build
    configure \
      'KERNEL_DIR=/usr/src/linux-headers-2.6.26-2-common',
      '--enable-apache',
      '--enable-battery',
      '--enable-bind',
      '--enable-conntrack',
      '--enable-contextswitch',
      '--enable-cpufreq',
      '--enable-cpu',
      '--enable-csv',
      '--enable-curl',
      '--enable-curl_json',
      '--enable-curl_xml',
      '--enable-dbi',
      '--enable-df',
      '--enable-disk',
      '--enable-dns',
      '--enable-email',
      '--enable-entropy',
      '--enable-exec',
      '--enable-filecount',
      '--enable-fscache',
      '--enable-hddtemp',
      '--enable-interface',
      '--enable-ipmi',
      '--enable-iptables',
      '--enable-ipvs',
      '--enable-irq',
      '--enable-load',
      '--enable-logfile',
      '--enable-match_empty_counter',
      '--enable-match_hashed',
      '--enable-match_regex',
      '--enable-match_timediff',
      '--enable-match_value',
      '--enable-mbmon',
      '--enable-memcachec',
      '--enable-memcached',
      '--enable-memory',
      '--enable-mysql',
      '--enable-network',
      '--enable-nfs',
      '--enable-nginx',
      '--enable-notify_email',
      '--enable-ntpd',
      '--enable-openvpn',
      '--enable-perl',
      '--enable-ping',
      '--enable-powerdns',
      '--enable-processes',
      '--enable-protocols',
      '--enable-python',
      '--enable-redis',
      '--enable-rrdtool',
      '--enable-sensors',
      '--enable-serial',
      '--enable-snmp',
      '--enable-swap',
      '--enable-syslog',
      '--enable-table',
      '--enable-tail',
      '--enable-target_notification',
      '--enable-target_replace',
      '--enable-target_scale',
      '--enable-target_set',
      '--enable-target_v5upgrade',
      '--enable-tcpconns',
      '--enable-ted',
      '--enable-thermal',
      '--enable-threshold',
      '--enable-unixsock',
      '--enable-uptime',
      '--enable-users',
      '--enable-uuid',
      '--enable-vmem',
      '--enable-vserver',
      '--enable-write_http',
      '--enable-write_redis',
      '--disable-debug',
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
