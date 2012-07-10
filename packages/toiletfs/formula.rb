class Toiletfs < DebianFormula
  homepage 'http://github.com/scottjg/toiletfs'
  url 'https://github.com/scottjg/toiletfs/tarball/v0.2'
  md5 '158a2a67c04ea7cb6e2f4bc14bca0adf'

  name 'toiletfs'
  section 'utils'
  version '0.2'
  description 'FUSE filesystem for storing coredumps'

  build_depends 'libfuse-dev'
  depends 'fuse-utils'
  provides 'toiletfs'

  def build
    make :destdir => prefix
  end
end
