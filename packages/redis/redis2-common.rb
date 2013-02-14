class Redis2 < DebianFormula
  def patches
    'fix-link-ordering.patch'
  end

  def build
    make

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! 'daemonize no', 'daemonize yes'
      s.gsub! 'logfile stdout', 'logfile /var/log/redis/redis-server.log'
      s.gsub! 'loglevel verbose', 'loglevel notice'

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
