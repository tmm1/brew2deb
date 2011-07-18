class Carbon < DebianFormula
  url 'http://launchpad.net/graphite/1.0/0.9.8/+download/carbon-0.9.8.tar.gz'
  md5 '611083ec9ad7418e7e72b962719204ae'

  name 'carbon'
  version '0.9.8'
  section 'python'
  description 'the Graphite backend'

  build_depends \
    'python'

  depends \
    'python',
    'python-twisted'

  def build
    %w( lib/carbon/conf.py conf/carbon.conf.example ).each do |file|
      inreplace file, "/opt/graphite/storage/whisper/", "/var/lib/graphite/whisper/"
    end

    rm 'setup.cfg'
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"

    Dir[prefix/'bin/*.py'].each do |path|
      inreplace path do |s|
        # use system paths
        s.gsub! /^STORAGE_DIR = .*$/, 'STORAGE_DIR = "/var/lib/graphite/"'
        s.gsub! "LOG_DIR = join(STORAGE_DIR, 'log',", "LOG_DIR = join('/var', 'log', 'graphite',"
        s.gsub! /^CONF_DIR = .*$/, 'CONF_DIR = "/etc/graphite/"'

        # put pidfiles in /var/run
        s.gsub! "'--pidfile', default=join(STORAGE_DIR,", "'--pidfile', default=join('/var/run/graphite',"

        # we're installing into system lib paths
        s.gsub! "sys.path.insert(0, LIB_DIR)\n", ''
      end

      # binaries don't need file extension
      mv path, path.gsub(/\.py$/,'')
    end

    share.mkpath
    mv prefix/'conf', share/'graphite'

    (etc/'graphite').mkpath
    Dir[share/'graphite/*.example'].each do |conf|
      cp conf, etc/'graphite'/File.basename(conf, '.example')
    end

    %w( lib log run ).each do |dir|
      (var/dir/'graphite').mkpath
    end
    rm_rf prefix/'storage'
  end
end
