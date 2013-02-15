class Collectd < DebianFormula
  homepage 'http://collectd.org/'
  url 'https://github.com/collectd/collectd/tarball/bd84c0f1'
  md5 '587be0059d76254e7df0cc56ec5e38ba'

  name 'collectd'
  section 'utils'
  version '5.1.0+github1'
  description 'statistics collection and monitoring daemon'

  build_depends \
    'python-dev',
    'bison',
    'libmysqlclient15-dev | libmysqlclient-dev',
    'libcurl4-openssl-dev | libcurl4-gnutls-dev',
    'pkg-config',
    'libdbi0-dev',
    'libesmtp-dev',
    'libgcrypt11-dev',
    'libiptcdata0-dev',
    'libmemcached-dev',
    'iproute-dev',
    'libsnmp-dev',
    'liboping-dev',
    'libpcap0.8-dev',
    'libltdl3-dev',
    'librrd-dev',
    'libyajl-dev',
    'iptables-dev',
    'linux-headers-2.6.32-5-common | linux-headers-2.6.26-2-common | linux-headers-3.2.0-32-virtual'

  depends \
    'python',
    'libmysqlclient15off | libmysqlclient16',
    'libcurl3',
    'libdbi0',
    'libesmtp5',
    'libgcrypt11',
    'libiptcdata0',
    'libmemcached3 | libmemcached5',
    'libsnmp15',
    'liboping0',
    'libpcap0.8',
    'librrd4',
    'libyajl1'

  config_files '/etc/collectd/collectd.conf'

  def build
    kernel = `uname -r`.chomp.sub(/-amd64/, '-common')
    sh './build.sh'
    configure \
      "KERNEL_DIR=/usr/src/linux-headers-#{kernel}-common",
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
      '--disable-ipmi',
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
      '--enable-netlink',
      '--with-libnetlink=/usr',
      '--enable-network',
      '--enable-nfs',
      '--enable-nginx',
      '--enable-notify_email',
      '--enable-ntpd',
      '--enable-openvpn',
      '--disable-perl',
      '--enable-ping',
      '--enable-powerdns',
      '--enable-processes',
      '--enable-protocols',
      '--enable-python',
      '--disable-redis',
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
      '--enable-debug',
      '--prefix=/usr',
      '--localstatedir=/var',
      '--sysconfdir=/etc/collectd'

    make
  end

  def install
    super
    (etc/'init.d').install_p(workdir/'init.d', 'collectd')
  end
end
