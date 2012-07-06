class Toiletfs < DebianFormula
  homepage 'http://github.com/scottjg/toiletfs'
  url 'https://github.com/scottjg/toiletfs/tarball/v0.1'
  md5 '4fcebe83dfb544b839267a1b8e1ff68c'

  name 'toiletfs'
  section 'utils'
  version '0.1'
  description 'FUSE filesystem for storing coredumps'

  build_depends 'libfuse-dev'
  depends 'fuse-utils'
  provides 'toiletfs'

  def build
    make :destdir => prefix
  end
end
