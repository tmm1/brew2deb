class Mtop < DebianFormula
  homepage 'http://mtop.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mtop/mtop/v0.6.6/mtop-0.6.6.tar.gz'
  md5 'f1beb021351f937a74cb0e9d3fcedae7'

  name 'mtop'
  version '0.6.6'
  description 'MySQL terminal based query monitor'
  section 'extra'

  build_depends 'perl'

  def build
    sh 'perl mtop.PL'
  end

  def install
    bin.install 'mtop'
  end
end
