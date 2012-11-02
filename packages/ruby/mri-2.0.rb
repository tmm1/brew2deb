require 'base'

class MRI < Ruby
  url 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-preview1.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 'c7d73f3ddb6d25e7733626ddbad04158'

  name 'rbenv-2.0.0-pre1'
  section 'interpreters'
  version '1.0.0'
  description 'The MRI Ruby virtual machine'

  depends 'rbenv'
  provides! 'rbenv-2.0'

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
    configure :prefix => prefix
    make
  end
end
