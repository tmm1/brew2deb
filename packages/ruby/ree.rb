require 'mri'

class REE < MRI
  homepage 'http://www.rubyenterpriseedition.com/'
  url 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.03.tar.gz'
  md5 '038604ce25349e54363c5df9cd535ec8'

  name 'ree'
  section 'interpreters'
  version '1.8.7-2011.03'
  description 'The REE Ruby virtual machine (installed in /opt)'

  build_depends \
    'ruby',
    'google-perftools'

  depends \
    'google-perftools'

  conflicts 'kiji'
  replaces  'kiji'
  provides  'kiji'

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
      '--auto', '/opt',
      '--destdir', destdir
  end

  private

  def prefix
    current_pathname_for('opt')
  end
end
