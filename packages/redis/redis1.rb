require 'redis2'

class Redis1 < Redis2
  url 'http://redis.googlecode.com/files/redis-1.2.1.tar.gz'
  md5 'b1f026ed495252e7820a2946a61f6f61'

  name 'redis1-server'
  version '1.2.1+github1'

  def build
    super

    inreplace "redis.conf" do |s|
      s.gsub! 'redis.pid', 'redis1.pid'
      s.gsub! 'redis.log', 'redis1.log'
      s.gsub! '/var/lib/redis', '/var/lib/redis1'
    end
  end

  def install
    super

    mv etc+'redis/redis.conf', etc+'redis/redis1.conf'
    mv etc+'init.d/redis-server', etc+'init.d/redis1-server'

    inreplace(etc+'init.d/redis1-server') do |s|
      s.gsub! 'redis-server', 'redis1-server'
      s.gsub! 'redis.conf', 'redis1.conf'
      s.gsub! 'redis.pid', 'redis1.pid'
    end

    Dir[bin+'redis-*'].each do |bin|
      mv bin, bin.gsub('redis-', 'redis1-')
    end
  end

  private

  def mv(*args)
    FileUtils.mv(*args)
  end
end
