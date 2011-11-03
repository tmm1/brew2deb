class GraphiteTrunk < DebianFormula
  SHA = 'f224e02'

  homepage 'http://launchpad.net/graphite'
  url 'https://github.com/tmm1/graphite.git', :sha => SHA

  source 'http://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.6.4.tar.gz'

  name 'graphite'
  version "0.9.9+github3-#{SHA}"
  section 'web'
  description 'Enterprise scalable realtime graphing'

  build_depends \
    'python-dev',
    'python-rrdtool',
    'librrd-dev',
    'libcairo2-dev'

  depends \
    'python',
    'python-rrdtool',
    'librrd4',
    'libcairo2',
    'libsqlite3-0'

  provides  'carbon', 'whisper'
  replaces  'carbon', 'whisper'
  conflicts 'carbon', 'whisper'

  requires_user 'carbon',
    :home => '/var/lib/carbon',
    :remove => false,
    :chown => [
      '/var/log/graphite',
      '/var/lib/graphite',
      '/var/log/carbon',
      '/var/lib/carbon'
    ]

  config_files \
    '/etc/carbon/carbon.conf',
    '/etc/carbon/storage-schemas.conf',
    '/etc/graphite/dashboard.conf',
    '/etc/graphite/gunicorn.conf',
    '/etc/graphite/graphTemplates.conf',
    '/usr/share/graphite/webapp/graphite/local_settings.py'

  def patches
    [
      'patches/carbon-setup.patch',
      'patches/carbon-config.patch',
      'patches/graphite-setup.patch',
      'patches/graphite-config.patch'
    ]
  end

  def build
    open 'webapp/graphite/local_settings.py', 'w' do |f|
      f.puts "TIME_ZONE = 'America/Los_Angeles'"
    end
  end

  def install
    venv = share/'graphite'
    pip = venv/'bin/pip'

    ENV['PIP_DOWNLOAD_CACHE'] = FileUtils.mkdir_p(workdir/'src'/'pip-download-cache')

    safe_system 'python', builddir/'virtualenv-1.6.4/virtualenv.py', '--distribute', '--no-site-packages', venv

    inreplace 'requirements.txt', 'py2cairo-1.8.10', 'pycairo-1.6.4'
    safe_system pip, 'install', '-r', 'requirements.txt'
    safe_system pip, 'install', 'gunicorn'
    safe_system pip, 'install', './carbon'

    ver = `python --version 2>&1`[/(2\.\d)/, 1]
    if rrdtool = %W[/usr/lib/python-support/python-rrdtool/python#{ver}/rrdtool.so /usr/lib/pyshared/python#{ver}/rrdtool.so].find{ |dir| Dir[dir].first }
      ln_s rrdtool, share/"graphite/lib/python#{ver}/site-packages/"
    end

    (prefix/'bin').mkpath

    install_whisper
    install_carbon
    install_graphite

    Dir[share/'graphite/bin/*'].each do |exe|
      inreplace exe do |s|
        s.gsub! destdir, ''
      end
    end
  end

  def install_whisper
    chdir 'whisper' do
      Dir['bin/*.py'].each do |path|
        ln_s "../share/graphite/bin/#{File.basename path}", prefix/'bin'
      end
    end
  end

  def install_carbon
    chdir 'carbon' do
      Dir['bin/*.py'].each do |path|
        ln_s "../share/graphite/bin/#{File.basename path}", prefix/'bin'
      end

      (etc/'carbon').install_p 'conf/carbon.conf.example', 'carbon.conf'
      (etc/'init.d').install_p workdir/'init.d-carbon', 'carbon'
      (var/'run').mkpath
      %w( cache relay aggregator ).each do |dir|
        (var/'log/carbon'/dir).mkpath
      end
      %w( whisper lists rrd ).each do |dir|
        (var/'lib/carbon'/dir).mkpath
      end

      open etc/'carbon/storage-schemas.conf', 'w' do |f|
        f.puts %(
          [mysql]
          pattern = ^mysql\.
          retentions = 30:720,60:10080,600:262974

          [carbon]
          pattern = ^carbon\.
          retentions = 60:90d

          [default]
          pattern = .*
          retentions = 10:6h,60:7d,600:5y
        ).ui
      end
    end
  end

  def install_graphite
    sh 'python', 'setup.py', 'install', "--prefix=#{share/'graphite'}", "--install-lib=#{share/'graphite/webapp'}"

    (etc/'graphite').mkpath
    (etc/'graphite').install_p 'conf/graphTemplates.conf.example', 'graphTemplates.conf'
    (etc/'init.d').install_p workdir/'init.d-graphite', 'graphite'
    (prefix/'bin').install workdir/'graphite-web'
    %w( log lib ).each do |dir|
      (var/dir/'graphite').mkpath
    end

    open etc/'graphite/gunicorn.conf', 'w' do |f|
      f.puts "proc_name = 'graphite'"
      f.puts "bind = '0.0.0.0:8000'"
      f.puts "workers = 6"
      f.puts "accesslog = '/var/log/graphite/access.log'"
      f.puts "errorlog = '/var/log/graphite/gunicorn.log'"
      f.puts "loglevel = 'debug'"
      f.puts "daemon = True"
      f.puts "pidfile = '/var/run/graphite.pid'"
    end
    ln_s '../../usr/share/graphite/webapp/graphite/local_settings.py', etc/'graphite/local_settings.py'
  end
end
