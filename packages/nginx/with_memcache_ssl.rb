require './formula'

class Nginx
  version << "+memcache-ssl7"

  build_depends \
    'libmemcache'

  depends \
    'libmemcache'

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => 'https://github.com/tmm1/nginx/compare/master...memcache-ssl-0.8.patch'}
  end

  def configure(*args)
    args.unshift '--with-memcache-ssl-session-store'
    super(*args)
  end
end
