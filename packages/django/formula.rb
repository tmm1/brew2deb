class Django < DebianFormula
  url 'http://www.djangoproject.com/download/1.3/tarball/', :as => 'Django-1.3.tar.gz'
  md5 '1b8f76e91c27564708649671f329551f'

  name 'django'
  version '1.3'
  section 'python'
  description 'high-level Python Web framework that encourages rapid development and clean, pragmatic design'

  build_depends 'python'
  depends 'python'
  conflicts 'python-django'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
