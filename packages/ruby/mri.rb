require 'base'

class MRI < Ruby
  url 'ftp://ftp.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p330.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 '50a49edb787211598d08e756e733e42e'

  name 'ruby-mri'
  section 'interpreters'
  version '1.8.7-p330'
  description 'The MRI Ruby virtual machine'

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
