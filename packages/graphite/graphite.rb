class Graphite < DebianFormula
  homepage 'https://launchpad.net/graphite'
  url 'http://launchpad.net/graphite/1.0/0.9.8/+download/graphite-web-0.9.8.tar.gz'
  md5 '1822e5db0535d7b0ce1f29c013b29c1f'

  name 'graphite'
  version '0.9.8+github1'
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
    'whisper',
    'carbon'

  requires_user 'graphite',
    :home => '/var/lib/graphite',
    :chown => [
      '/var/log/graphite',
      '/var/lib/graphite'
    ]

  config_files \
    '/etc/graphite/dashboard.conf'

  def patches
    [
      'patches/graphite-setup.patch',
      'patches/graphite-config.patch'
    ]
  end

  def build
    open 'webapp/graphite/local_settings.py', 'w' do |f|
      f.puts "DEBUG = True"
      f.puts "TIME_ZONE = 'America/Los_Angeles'"
    end

    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--root=#{destdir}", "--install-purelib=/usr/share/graphite/webapp/"

    (etc/'graphite').install_p 'conf/dashboard.conf.example', 'dashboard.conf'
    (etc/'init.d').install_p workdir/'init.d-graphite', 'graphite'
    %w( log lib ).each do |dir|
      (var/dir/'graphite').mkpath
    end

    open etc/'graphite/gunicorn.conf.py', 'w' do |f|
      f.puts "bind = '0.0.0.0:8000'"
      f.puts "workers = 3"
      f.puts "log_file = '/var/log/graphite/webapp/gunicorn.log'"
      f.puts "daemon = True"
      f.puts "pidfile = '/var/run/graphite/gunicorn.pid'"
    end
    ln_s '../../usr/share/graphite/webapp/graphite/local_settings.py', etc/'graphite/graphite.conf.py'
  end
end
