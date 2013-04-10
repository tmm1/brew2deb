class Jemalloc < DebianFormula
  homepage 'http://www.canonware.com/jemalloc/'
  url "http://www.canonware.com/download/jemalloc/jemalloc-3.2.0.tar.bz2"
  sha1 'e5204872e74d3ee75eaa51c6dc39731d611883f3'

  name 'jemalloc'
  version '3.2.0+github1'
  section 'system'
  description 'general-purpose scalable concurrent malloc(3) implementation'

  depends 'libunwind7'
  build_depends 'libunwind7-dev'

  def build
    configure :prefix => prefix, :enable_prof => true, :enable_prof_libunwind => true
    make
  end

  def install
    super
    system "mv #{destdir}/usr/bin/pprof #{destdir}/usr/bin/pprof-jemalloc"
  end
end
