class PuppetDB < DebianFormula
  homepage 'http://docs.puppetlabs.com/puppetdb/1.1/index.html'
  url 'https://github.com/puppetlabs/puppetdb.git', :sha => '92ceef0907ae2afa2047af34ed8526abd6e9f6ba'

  name 'puppetdb'
  version '1.1.1+github1'
  description 'next-generation open source storage service for Puppet-produced data'
  section 'database'
  arch 'all'
  
  build_depends \
    'leiningen',
    'facter'
    
  depends \
    'oracle-java7-jdk'

  requires_user 'puppetdb',
    :home   => '/usr/share/puppetdb',
    :remove => false,
    :chown  => [
      '/etc/puppetdb',
      '/usr/share/puppetdb',
      '/var/lib/puppetdb',
      '/var/log/puppetdb'
    ]

  def build
    sh 'lein', 'uberjar'
    mv 'target/puppetdb-nil-standalone.jar', 'puppetdb.jar'
  end

  def install
    (var/'lib/puppetdb').mkpath
    (var/'lib/puppetdb/state').mkpath
    (var/'lib/puppetdb/db').mkpath
    (var/'lib/puppetdb/mq').mkpath
    
    (var/'log/puppetdb').mkpath
    
    (etc/'puppetdb').mkpath
    (etc/'puppetdb/conf.d').mkpath
    (etc/'puppetdb/conf.d').install_p Dir[builddir/'ext/files/*.ini']
    
    (prefix/'share/puppetdb').mkpath
    (prefix/'share/puppetdb').install builddir/'puppetdb.jar'
    
    (etc/'logrotate.d').install builddir/'ext/files/puppetdb.logrotate', 'puppetdb'
    (etc/'default').install builddir/'ext/files/puppetdb.default', 'puppetdb'
    (etc/'init.d').install builddir/'ext/files/puppetdb.debian.init', 'puppetdb'
    (prefix/'sbin').install Dir[builddir/'ext/files/puppetdb-*']
  end
end
