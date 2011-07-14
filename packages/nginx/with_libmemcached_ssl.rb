require './formula'

class Nginx
  version << "+libmemcached-ssl3"

  build_depends \
    'libmemcached-dev'

  depends \
    'libmemcached3'

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => ['https://github.com/tmm1/nginx/compare/master...libmemcached-ssl.patch', 'no-tls-tickets.patch']}
  end

  def configure(*args)
    args.unshift '--with-memcache-ssl-session-store'
    super(*args)
  end
end
