require './formula'

class Nginx
  version << "+libmemcached-ssl4"

  build_depends \
    'libmemcached-dev'

  depends \
    'libmemcached3',
    'libssl0.9.8 (>= 0.9.8o)'

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => ['https://github.com/tmm1/nginx/compare/master...libmemcached-ssl.patch', 'no-tls-tickets.patch']}
  end

  def configure(*args)
    args.unshift '--with-memcache-ssl-session-store'
    super(*args)
  end
end
