class GooglePerftools < DebianFormula
  homepage 'http://code.google.com/p/google-perftools/'
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.7.tar.gz'
  md5 '5839cab3723e68a86ed327ebb54d54bc'

  name 'google-perftools'
  section 'devel'
  version '1.7'
  description 'Fast, multi-threaded malloc() and nifty performance analysis tools'

  build_depends \
    'libunwind7-dev'

  depends \
    'libunwind7'
end
