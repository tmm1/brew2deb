require 'yarv'

class YARV2 < YARV
  url 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p0.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 '50d307c4dc9297ae59952527be4e755d'

  name 'rbenv-2.0.0-p0'
  section 'interpreters'
  version '1.0.0'
  description 'The YARV 2.0 Ruby virtual machine'

  depends 'rbenv'
  provides! 'rbenv-2.0'

  build_depends \
    'google-perftools (>= 1.8), google-perftools (<= 1.9)',
    'jemalloc'

  depends \
    'google-perftools (>= 1.8), google-perftools (<= 1.9)',
    'jemalloc'

  def install
    make 'ruby'
    super
    bin.install_p 'ruby', 'ruby-libcmalloc'
    (include/'ruby-2.0.0').install Dir['*.{h,inc}']

    # wait to touch version.h last modified timestamp (1 sec resolution),
    # so make recognizes the change and rebuilds
    sleep 1

    make 'ruby-tcmalloc', 'RUBY_INSTALL_NAME=ruby-tcmalloc', 'MAINLIBS=-ltcmalloc'
    bin.install 'ruby-tcmalloc'
    bin.install_p 'ruby-tcmalloc', 'ruby'

    sleep 1

    make 'ruby-jemalloc', 'RUBY_INSTALL_NAME=ruby-jemalloc', 'MAINLIBS=-ljemalloc'
    bin.install 'ruby-jemalloc'
  end
end
