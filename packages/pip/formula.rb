class Pip < DebianFormula
  url 'http://pypi.python.org/packages/source/p/pip/pip-1.0.tar.gz'
  version '1.0-github'
  name 'pip-github'
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
