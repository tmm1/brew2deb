require 'mri'

class REE < MRI
  homepage 'http://www.rubyenterpriseedition.com/'
  url 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2012.02.tar.gz'
  md5 '8d086d2fe68a4c57ba76228e97fb3116'

  name 'rbenv-ree-jemalloc-1.8.7-2012.02'
  version '1.0.2+jemalloc'
  description 'The REE Ruby virtual machine'

  build_depends \
    'ruby',
    'jemalloc (>= 3.2.0)'

  depends \
    'jemalloc (>= 3.2.0)'

  provides! 'rbenv-ree'

  def patches
    [
      'patches/gc-free-slots.patch',
      'patches/gc-hooks.patch'
    ]
  end

  def build
  end

  def install
    ENV['CFLAGS'] = '-O2 -ggdb -Wall -fPIC -fno-builtin-malloc
     -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
     -fno-stack-protector'.gsub(/\s+/, ' ')
    ENV['LIBS'] = '-ljemalloc'

    sh './installer',
      '--no-dev-docs',
      '--no-tcmalloc',
      '--dont-install-useful-gems',
      '--auto', prefix.to_s.gsub(destdir,''),
      '--destdir', destdir
  end
end
