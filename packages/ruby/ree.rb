require 'mri'

class RubyREE < RubyMRI
  homepage 'http://www.rubyenterpriseedition.com/'
  url 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.03.tar.gz'
  md5 '038604ce25349e54363c5df9cd535ec8'

  name 'ruby-ree'
  section 'interpreters'
  version '1.8.7-2011.03'
  description 'The REE Ruby virtual machine'

  build_depends \
    'ruby',
    'google-perftools'

  depends \
    'google-perftools'

  def build
  end

  def install
    ENV['CFLAGS'] = '-O2 -ggdb -Wall -fPIC -fno-builtin-malloc
     -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
     -fno-stack-protector'.gsub(/\s+/, ' ')
    ENV['LIBS'] = '-ltcmalloc_minimal'

    sh './installer',
      '--no-dev-docs',
      '--no-tcmalloc',
      '--dont-install-useful-gems',
      '--auto', '/usr',
      '--destdir', destdir
  end
end
