require 'base'

class MRI < Ruby
  url 'ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p357.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 'b2b8248ff5097cfd629f5b9768d1df82'

  name 'rbenv-1.8.7-p357'
  section 'interpreters'
  version '1.0.0'
  description 'The MRI Ruby virtual machine'

  depends 'rbenv'
  provides! 'rbenv-1.8', 'rbenv-1.8.7'

  build_depends \
    'autoconf',
    'libreadline6-dev | libreadline5-dev',
    'bison',
    'zlib1g-dev',
    'libssl-dev'

  depends \
    'libreadline6 | libreadline5',
    'zlib1g',
    'openssl'

  def build
    ENV['CFLAGS'] = '-ggdb'

    configure :prefix => prefix
    make
  end
end
