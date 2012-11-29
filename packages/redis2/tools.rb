class RedisTools < DebianFormula
  homepage 'https://github.com/antirez/redis-tools'
  head 'https://github.com/antirez/redis-tools.git'

  name 'redis-tools'
  section 'utilities'
  version '0.1.0'
  description 'Redis toolset'

  def build
    make
  end

  def install
    bin.install Dir['redis-{stat,load}']
  end
end
