class Graphite < DebianFormula
  homepage 'https://launchpad.net/graphite'
  url 'http://launchpad.net/graphite/1.0/0.9.8/+download/graphite-web-0.9.8.tar.gz'
  md5 '1822e5db0535d7b0ce1f29c013b29c1f'

  name 'graphite'
  version '0.9.8'
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
    :remove => false,
    :chown => [
      '/var/log/graphite',
      '/var/lib/graphite'
    ]

  config_files \
    '/etc/graphite/dashboard.conf'

  def build
    inreplace 'webapp/graphite/settings.py' do |s|
      # use system paths
      s.gsub! /^STORAGE_DIR = .*$/, 'STORAGE_DIR = "/var/lib/graphite/"'
      s.gsub! /^LOG_DIR = .*$/, 'LOG_DIR = "/var/log/graphite/webapp/"'
      s.gsub! /^CONF_DIR = .*$/, 'CONF_DIR = "/etc/graphite/"'
    end

    sh 'python', 'setup.py', 'build'
  end

  def install
    (var/'lib/graphite').mkpath
    (var/'log/graphite/webapp').mkpath
    (share/'graphite').install 'webapp'
    cp Dir['conf/*'], share/'graphite'

    # config
    (etc/'graphite').mkpath
    cp share/'graphite/dashboard.conf.example', etc/'graphite/dashboard.conf'

    open(share/'graphite/webapp/graphite/local_settings.py','w') do |f|
      f.puts "DEBUG = True"
    end
    ln_s '../../usr/share/graphite/webapp/graphite/local_settings.py', etc/'graphite/graphite.conf.py'

    open(etc/'graphite/gunicorn.conf.py','w') do |f|
      f.puts "bind = '0.0.0.0:8000'"
      f.puts "workers = 3"
      f.puts "log_file = '/var/log/graphite/webapp/gunicorn.log'"
      f.puts "daemon = True"
      f.puts "pidfile = '/var/run/graphite/gunicorn.pid'"
    end

    (etc/'init.d').mkpath
    cp workdir/'init.d-graphite', etc/'init.d/graphite'
  end
end
