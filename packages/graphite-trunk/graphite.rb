class Graphite < DebianFormula
  homepage 'http://launchpad.net/graphite'
  url 'https://github.com/tmm1/graphite.git', :tag => '871ee7b'

  name 'graphite'
  version '0.9.9-pre2'
  section 'python'
  description 'Enterprise scalable realtime graphing'

  build_depends 'python'
  depends \
    'python',
    'python-cairo',
    'python-simplejson',
    'python-memcache',
    'libsqlite3-0',
    'gunicorn',
    'django',
    'whisper (>= 0.9.9)',
    'carbon (>= 0.9.9)'

  requires_user 'carbon',
    :home => '/var/lib/carbon',
    :remove => false,
    :chown => [
      '/var/log/graphite',
      '/var/lib/graphite'
    ]

  config_files \
    '/etc/graphite/dashboard.conf',
    '/etc/graphite/gunicorn.conf',
    '/usr/share/graphite/webapp/graphite/local_settings.py'

  def patches
    [
      'patches/graphite-setup.patch',
      'patches/graphite-config.patch'
    ]
  end

  def build
    open 'webapp/graphite/local_settings.py', 'w' do |f|
      f.puts "TIME_ZONE = 'America/Los_Angeles'"
    end

    sh 'python', 'setup.py', 'build'
  end

  def install
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
      f.puts "logfile = '/var/log/graphite/gunicorn.log'"
      f.puts "loglevel = 'debug'"
      f.puts "daemon = True"
      f.puts "pidfile = '/var/run/graphite.pid'"
    end
    ln_s '../../usr/share/graphite/webapp/graphite/local_settings.py', etc/'graphite/local_settings.py'
  end
end
