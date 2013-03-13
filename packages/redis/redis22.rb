require 'redis2-common'

class Redis22 < Redis2
  homepage 'http://redis.io/'
  head 'https://github.com/antirez/redis.git'
  url 'http://redis.googlecode.com/files/redis-2.2.5.tar.gz'
  md5 'fe6395bbd2cadc45f4f20f6bbe05ed09'

  name 'redis2-server'
  section 'database'
  version '2.2.5+github2'
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
    'fix-link-ordering.patch'
  end
end