require './formula'

class Nginx
  version << "+memcachessl"

  build_depends \
    'libmemcache-dev'

  depends \
    'libmemcache0'

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => 'https://github.com/mpalmer/nginx/compare/master...memcache-ssl-0.8.patch'}
  end

  def configure(*args)
    args.unshift '--with-memcache-ssl-session-store'
    super(*args)
  end
end
