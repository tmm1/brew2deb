class LibMemcache < DebianFormula
  homepage 'http://people.freebsd.org/~seanc/libmemcache/README'
  url 'http://people.freebsd.org/~seanc/libmemcache/libmemcache-1.4.0.rc2.tar.bz2'
  md5 '402c957cd71538c07a263542eeb513d1'

  name 'libmemcache'
  section 'libs'
  version '1.4.0.rc2+github1'
  description 'the old C API for memcached(8)'

  conflicts 'libmemcache-dev', 'libmemcache0'
  replaces  'libmemcache-dev', 'libmemcache0'
  provides  'libmemcache-dev', 'libmemcache0'

  def patches
    {:p0 => 'double-free.patch',
     :p1 => 'inline-headers.patch'}
  end
end
