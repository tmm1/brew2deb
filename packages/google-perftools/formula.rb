class GooglePerftools < DebianFormula
  homepage 'http://code.google.com/p/google-perftools/'
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.8.3.tar.gz'
  md5 '70c95322c9bac97e67f0162e4cc55996'

  name 'google-perftools'
  section 'devel'
  version '1.8.3+github1'
  description 'Fast, multi-threaded malloc() and nifty performance analysis tools'

  build_depends \
    'libunwind7-dev'

  depends \
    'libunwind7'

  conflicts 'libgoogle-perftools-dev', 'libgoogle-perftools0', 'libtcmalloc-minimal0'
  replaces  'libgoogle-perftools-dev', 'libgoogle-perftools0', 'libtcmalloc-minimal0'
  provides  'libgoogle-perftools-dev', 'libgoogle-perftools0', 'libtcmalloc-minimal0'
end
