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
    inreplace 'Rakefile' do |s|
      # I hate this with the passion of a thousand suns
      s.concat "\n\n"
      s.concat <<-EOC.undent
        def erb(erbfile,  outfile)
          if ENV['SOURCEINSTALL'] == 1
            @install_dir = "#{DESTDIR}/@install_dir"
            @config_dir = "#{DESTDIR}/@config_dir"
            @initscriptname = "#{DESTDIR}/@initscript"
            @log_dir = "#{DESTDIR}/@log_dir"
            @lib_dir = "#{DESTDIR}/@lib_dir"
            @link = "#{DESTDIR}/@link"
          end
          template = File.read(erbfile)
          message = ERB.new(template, nil, "-")
          output = message.result(binding)
          File.open(outfile, 'w') { |f| f.write output }
          puts "Generated: #{outfile}"
        end
  
      EOC
      s.gsub! ':default => [ :package ]', ':default => [ :template ]'
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

    [ 'puppetdb', 'puppetdb/conf.d' ].each { |p| (etc+p).mkpath }
    
    (prefix/'share/puppetdb').mkpath
    (prefix/'share/puppetdb').install_p builddir/'puppetdb.git/target/puppetdb-nil-standalone.jar', 'puppetdb.jar'
    
    (etc/'puppetdb/conf.d').install Dir[workingdir/'puppetdb.git/ext/files/*.ini']
    (etc/'logrotate.d').install_p builddir/'puppetdb.git/ext/files/puppetdb.logrotate', 'puppetdb'
    (etc/'default').install_p builddir/'puppetdb.git/ext/files/puppetdb.default', 'puppetdb'
    (etc/'init.d').install_p builddir/'puppetdb.git/ext/files/puppetdb.debian.init', 'puppetdb'
    (prefix/'sbin').install Dir[builddir/'puppetdb.git/ext/files/puppetdb-*']
  end
end
