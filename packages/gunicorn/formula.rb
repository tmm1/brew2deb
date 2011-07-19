class GUnicorn < DebianFormula
  url 'https://github.com/benoitc/gunicorn.git', :tag => '0.12.2'

  name 'gunicorn'
  version '0.12.2+github1'
  section 'python'
  description 'Green Unicorn: a WSGI HTTP Server for UNIX'

  build_depends 'python', 'python-setuptools'
  depends 'python', 'python-pkg-resources'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    ver = `python --version 2>&1`[/(2\.\d)/, 1]
    path = prefix/"lib/python#{ver}/site-packages/"

    ENV['PYTHONPATH'] = path
    path.mkpath
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"

    rm Dir[path/'{site.p*,*.pth}']
  end
end
