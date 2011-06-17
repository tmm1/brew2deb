class Htop < DebianFormula
  homepage 'http://htop.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/htop/htop/0.9/htop-0.9.tar.gz'
  md5 '7c5507f35f363f3f40183a2ba3c561f8'

  name 'htop'
  section 'utils'
  version '0.9+github1'
  description 'an interactive process viewer for Linux'

  build_depends 'libncurses-dev'
  depends 'libncurses5'

  def build
    sh './configure', "--prefix=#{prefix}"
    make
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end
