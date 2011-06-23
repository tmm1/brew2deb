class Redis < DebianFormula
  homepage 'http://redis.io/'
  head 'https://github.com/antirez/redis.git'
  url 'http://redis.googlecode.com/files/redis-2.2.5.tar.gz'
  md5 'fe6395bbd2cadc45f4f20f6bbe05ed09'

  section 'database'
  name 'redis-server'
  version '2.2.5+github1'
  description 'An advanced key-value store.'

  def build
    make

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! 'daemonize no', 'daemonize yes'
      s.gsub! 'logfile stdout', 'logfile /var/log/redis.log'
      s.gsub! 'loglevel verbose', 'loglevel notice'

      s.gsub! 'dir ./', 'dir /var/lib/redis/'
      s.gsub! '/var/run/redis.pid', '/var/run/redis.pid'
    end
  end

  def install
    %w( run lib/redis log ).each { |p| (var+p).mkpath }

    # Head and stable have different code layouts
    src = File.exists?('src/Makefile') ? 'src' : '.'

    %w( redis-benchmark redis-cli redis-server redis-check-dump redis-check-aof ).each { |p|
      bin.install "#{src}/#{p}"
    }

    doc.install Dir["doc/*"]
    (etc+'redis').install "redis.conf"
    (etc+'init.d').install_p(workdir+'redis-server.init.d', 'redis-server')
  end
end
