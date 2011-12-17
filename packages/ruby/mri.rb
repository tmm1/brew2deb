require 'base'

class MRI < Ruby
  url 'ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p352.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 '0c33f663a10a540ea65677bb755e57a7'

  name 'rbenv-1.8.7-p352'
  section 'interpreters'
  version '1.0.0'
  description 'The MRI Ruby virtual machine'

  depends 'rbenv'
  provides! 'rbenv-1.8', 'rbenv-1.8.7'

  build_depends \
    'autoconf',
    'libreadline5-dev',
    'bison',
    'zlib1g-dev',
    'libssl-dev'

  depends \
    'libreadline5',
    'zlib1g',
    'openssl'

  def build
    ENV['CFLAGS'] = '-ggdb'

    configure :prefix => prefix
    make
  end
end
