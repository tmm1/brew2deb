class Carbon < DebianFormula
  homepage 'http://launchpad.net/graphite'
  url 'https://github.com/tmm1/graphite.git', :tag => '871ee7b'

  name 'carbon'
  version '0.9.9-pre2'
  section 'python'
  description 'the Graphite backend'

  build_depends \
    'python'

  depends \
    'python',
    'python-twisted',
    'python-pkg-resources',
    'whisper (>= 0.9.9)'

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
      'patches/carbon-config.patch',
      'patches/carbon-aggregation-hax.patch'
    ]
  end

  def build
    chdir 'carbon' do
      sh 'python', 'setup.py', 'build'
    end
  end

  def install
    chdir 'carbon' do
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
          pattern = .*
          retentions = 10:6h,60:7d,600:5y
        ).ui
      end
    end
  end
end
