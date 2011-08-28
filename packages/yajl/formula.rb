class Yajl < DebianFormula
  homepage 'http://lloyd.github.com/yajl/'
  url 'http://github.com/lloyd/yajl/tarball/1.0.12'
  md5 '70d2291638233d0ab3f5fd3239d5ed12'

  name 'yajl'
  section 'libs'
  version '1.0.12'
  description 'Yet Another JSON Library - A Portable JSON parsing and serialization library in ANSI C'

  provides 'libyajl-dev', 'libyajl1', 'yajl-tools'
  conflicts 'libyajl-dev', 'libyajl1', 'yajl-tools'
  replaces 'libyajl-dev', 'libyajl1', 'yajl-tools'

  build_depends 'cmake'
end
