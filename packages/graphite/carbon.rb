class Carbon < DebianFormula
  homepage 'http://graphite.wikidot.com/carbon'
  url 'http://launchpad.net/graphite/1.0/0.9.8/+download/carbon-0.9.8.tar.gz'
  md5 '611083ec9ad7418e7e72b962719204ae'

  name 'carbon'
  version '0.9.8+github3'
  section 'python'
  description 'the Graphite backend'

  build_depends \
    'python'

  depends \
    'python',
    'python-twisted',
    'python-pkg-resources'

  requires_user 'carbon',
    :home => '/var/lib/carbon',
    :chown => [
      '/var/log/carbon',
      '/var/lib/carbon'
    ]

  config_files \
    '/etc/carbon/carbon.conf',
    '/etc/carbon/storage-schemas.conf'

  def patches
    [
      'patches/carbon-setup.patch',
      'patches/carbon-scripts.patch',
      'patches/carbon-config.patch',
      'patches/carbon-status-exit-code.patch',
      'patches/carbon-udp-receiver.patch'
    ]
  end

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"

    Dir[prefix/'bin/*.py'].each do |path|
      mv path, path.gsub(/\.py$/,'')
    end

    (share/'carbon').install Dir['conf/*.example']
    (etc/'carbon').install_p 'conf/carbon.conf.example', 'carbon.conf'
    (etc/'init.d').install_p workdir/'init.d-carbon', 'carbon'
    (var/'run').mkpath
    %w( cache relay aggregator ).each do |dir|
      (var/'log/carbon'/dir).mkpath
    end

    open etc/'carbon/storage-schemas.conf', 'w' do |f|
      f.puts %(
        [default]
        priority = 110
        pattern = .*
        retentions = 10:2160,60:10080,600:262974
      ).ui
    end
  end
end
