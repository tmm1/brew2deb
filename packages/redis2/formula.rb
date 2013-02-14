class Redis2 < DebianFormula
  homepage 'http://redis.io/'
  head 'https://github.com/antirez/redis.git'
  url 'http://redis.googlecode.com/files/redis-2.6.10.tar.gz'
  md5 '711b472b14084863699987786a378d87'

  name 'redis2-server'
  section 'database'
  version '2.6.10+github'
  description 'An advanced key-value store.'

  conflicts 'redis-server'

  config_files \
    '/etc/redis/redis.conf'

  requires_user 'redis',
    :home => '/var/lib/redis',
    :remove => false,
    :chown => [
      '/var/log/redis',
      '/var/lib/redis',
    ]

  def build
    make

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! 'daemonize no', 'daemonize yes'
      s.gsub! 'logfile stdout', 'logfile /var/log/redis/redis-server.log'

      s.gsub! 'dir ./', 'dir /var/lib/redis/'
      s.gsub! '/var/run/redis.pid', '/var/run/redis.pid'
    end
  end

  def install
    %w( run lib/redis log/redis ).each { |p| (var+p).mkpath }

    # Head and stable have different code layouts
    src = File.exists?('src/Makefile') ? 'src' : '.'
    bin.install Dir["#{src}/redis-*"].select{ |f| f =~ /redis-[^\.]+$/ }

    (etc+'redis').install "redis.conf"
    (etc+'init.d').install_p(workdir+'redis-server.init.d', 'redis-server')
  end
end
