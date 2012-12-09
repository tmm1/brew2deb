class GPerftools < DebianFormula
  homepage 'http://code.google.com/p/gperftools/'
  url 'http://gperftools.googlecode.com/files/gperftools-2.0.tar.gz'
  md5 '13f6e8961bc6a26749783137995786b6'

  name 'gperftools'
  section 'devel'
  version '2.0.0+github1'
  description 'Fast, multi-threaded malloc() and nifty performance analysis tools'

  build_depends \
    'libunwind7-dev'

  depends \
    'libunwind7'

  conflicts 'google-perftools', 'libgoogle-perftools-dev', 'libgoogle-perftools0', 'libtcmalloc-minimal0'
  replaces  'google-perftools', 'libgoogle-perftools-dev', 'libgoogle-perftools0', 'libtcmalloc-minimal0'
  provides  'google-perftools', 'libgoogle-perftools-dev', 'libgoogle-perftools0', 'libtcmalloc-minimal0'
end
