require 'base'

class MRI < Ruby
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 '8e2fef56185cfbaf29d0c8329fc77c05'

  name 'ruby-mri-1.9'
  section 'interpreters'
  version '1.9.3-p0'
  description 'The MRI Ruby virtual machine'

  build_depends \
    'autoconf',
    'libreadline5-dev',
    'bison',
    'zlib1g-dev',
    'libssl-dev',
    'libyaml-dev'

  depends \
    'libreadline5',
    'zlib1g',
    'openssl',
    'libyaml-0-1'

  def build
    ENV['CFLAGS'] = '-ggdb'

    configure :prefix => prefix
    make
  end
end
