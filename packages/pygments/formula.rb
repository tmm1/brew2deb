class Pygments < DebianFormula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.5.tar.gz'
  md5 'ef997066cc9ee7a47d01fb4f3da0b5ff'
  homepage 'http://pygments.pocoo.org/'
  description 'syntax highlighting package written in Python'
  arch 'all'

  name 'python-pygments'
  section 'python'
  version '1.5+github2'

  build_depends 'python', 'python-dev'
  depends 'python'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', '--install-layout=deb', "--root=#{destdir}"
  end
end
