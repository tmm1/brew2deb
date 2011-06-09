class Redis < DebianFormula
  url 'http://redis.googlecode.com/files/redis-2.2.8.tar.gz'
  head 'https://github.com/antirez/redis.git'
  homepage 'http://redis.io/'
  md5 '106af5e3d4646588fd27be499227e14c'

  section 'database'
  name 'redis-server'
  version '2.2.8+github1'
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
