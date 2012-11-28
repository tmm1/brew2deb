class Pygments < DebianFormula
  url 'http://pypi.python.org/packages/source/P/Pygments/Pygments-1.5.tar.gz'
  md5 'ef997066cc9ee7a47d01fb4f3da0b5ff'
  homepage 'http://pygments.pocoo.org/'
  description 'syntax highlighting package written in Python'
  arch 'all'

  name 'python-pygments'
  section 'python'
  version '1.5+github2'

  build_depends 'python', 'python-setuptools', 'python-dev'
  depends 'python', 'python-pkg-resources', 'python-support'

  def python_version
    `python -c 'import sys; print sys.version[:5]'`.strip
  end

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    if python_version == "2.5.2"
      bin.install 'pygmentize'
      man1.install 'docs/pygmentize.1'
      doc.install Dir['docs/build/*']
      (share/"python-support"/"python-pygments").install Dir['build/lib/*']
      (share/"python-support"/"python-pygments").install Dir['Pygments.egg-info']
    else
      sh 'python', 'setup.py', 'install', '--install-layout=deb', "--root=#{destdir}"
    end
  end
end
