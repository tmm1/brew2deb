class Docutils < DebianSourceFormula
  url 'http://prdownloads.sourceforge.net/docutils/docutils-0.9.1.tar.gz'
  version '0.9.1-1'
  name 'docutils'
  arch 'all'

  build_depends 'python'
  depends 'python'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', '--install-layout=deb', "--root=#{destdir}"
  end
end
