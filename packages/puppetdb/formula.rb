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
      '/var/lib/puppetdb',
    ]

  def build
    inreplace 'Rakefile' do |s|
      s.gsub! ':default => [ :package ]', ':default => [ :template ]'

      # I hate this with the passion of a thousand suns
      s << "\n\n"
      s << "def erb(erbfile,  outfile)\n"
      s << "  template = File.read(erbfile)\n"
      s << "  message = ERB.new(template, nil, '-')\n"
      s << "  output = message.result(binding)\n"
      s << "  File.open(outfile, 'w') { |f| f.write output }\n"
      s << "end"
    end

    sh 'rake'
    sh 'lein', 'uberjar'
  end

  def install
    [ 'lib/puppetdb',
      'lib/puppetdb/state',
      'lib/puppetdb/db',
      'lib/puppetdb/mq',
      'log/puppetdb',
    ].each { |p| (var+p).mkpath }

    chmod 0775, var/'log/puppetdb',

    [ 'puppetdb', 'puppetdb/conf.d' ].each { |p| (etc+p).mkpath }

    (prefix/'share/puppetdb').mkpath
    (prefix/'share/puppetdb').install_p builddir/'puppetdb.git/target/puppetdb-nil-standalone.jar', 'puppetdb.jar'
    (prefix/'sbin').install Dir[builddir/'puppetdb.git/ext/files/puppetdb-*']

    (etc/'puppetdb/conf.d').install Dir[builddir/'puppetdb.git/ext/files/*.ini']
    (etc/'logrotate.d').install_p builddir/'puppetdb.git/ext/files/puppetdb.logrotate', 'puppetdb'
    (etc/'default').install_p builddir/'puppetdb.git/ext/files/puppetdb.default', 'puppetdb'

    (etc/'init.d').install_p builddir/'puppetdb.git/ext/files/puppetdb.debian.init', 'puppetdb'
    chmod 0755, etc/'init.d/puppetdb'
  end
end
