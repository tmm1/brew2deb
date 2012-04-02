class Pygments < DebianFormula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.5.tar.gz'
  md5 'ef997066cc9ee7a47d01fb4f3da0b5ff'
  homepage 'http://pygments.pocoo.org/'
  description 'syntax highlighting package written in Python'
  arch 'all'

  name 'python-pygments'
  section 'python'
  version '1.5+github1'

  build_depends 'python', 'python-setuptools', 'python-dev'
  depends 'python', 'python-pkg-resources', 'python-support'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end


  def install
    bin.install 'pygmentize'
    man1.install 'docs/pygmentize.1'
    doc.install Dir['docs/build/*']
    (share/"python-support"/"python-pygments").install Dir['build/lib/*']
    (share/"python-support"/"python-pygments").install Dir['Pygments.egg-info']
  end
end
