class Graphite < DebianFormula
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

  def build
    inreplace 'webapp/graphite/settings.py' do |s|
      # use system paths
      s.gsub! /^STORAGE_DIR = .*$/, 'STORAGE_DIR = "/var/lib/graphite/"'
      s.gsub! /^LOG_DIR = .*$/, 'LOG_DIR = "/var/log/graphite/webapp/"'
      s.gsub! /^CONF_DIR = .*$/, 'CONF_DIR = "/etc/graphite/"'
    end
  end

  def install
    (var/'lib/graphite').mkpath
    (var/'log/graphite/webapp').mkpath
    (share/'graphite').install 'webapp'
    mv Dir['conf/*'], share/'graphite'

    # setup sqlite db
    File.open(share/'graphite/webapp/graphite/local_settings.py','w') do |f|
      f.puts "DATABASE_NAME = '#{var/'lib/graphite/graphite.db'}'"
    end
    chdir share/'graphite/webapp/graphite' do
      sh 'python', 'manage.py', 'syncdb', '--noinput'
    end

    rm share/'graphite/webapp/graphite/local_settings.py'
  end
end
