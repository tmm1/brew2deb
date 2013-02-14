require 'redis2-common'

class Redis26 < Redis2
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

  def patches
  end
end
