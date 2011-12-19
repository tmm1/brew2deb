class Pygments < DebianFormula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.4.tar.gz'
  md5 'd77ac8c93a7fb27545f2522abe9cc462'
  homepage 'http://pygments.pocoo.org/'
  description 'syntax highlighting package written in Python'
  arch 'all'

  name 'python-pygments'
  section 'python'
  version '1.4+github1'

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
