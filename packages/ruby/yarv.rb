require 'mri'

class YARV < MRI
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 'bc0c715c69da4d1d8bd57069c19f6c0e'

  source 'https://rubygems.org/downloads/bundler-1.2.0.rc.gem'

  name 'rbenv-1.9.3-p194'
  section 'interpreters'
  version '1.0.2'
  description 'The YARV Ruby virtual machine'

  provides! 'rbenv-1.9', 'rbenv-1.9.3'

  build_depends \
    'libyaml-dev'

  def configure(opts={})
    super opts.merge(:disable_install_rdoc => true)
  end

  def install_rubygems
    # bundled with 1.9
  end
  alias install_rake install_rubygems

  def install_bundler
    setup_rubylib

    install_gem builddir/'bundler-1.2.0.rc.gem'
    fix_shebangs 'bundle'
  end

  def rubylib
    `strings #{prefix/'bin/ruby'}`.split("\n").grep(/versions/).grep(/lib/).map{ |lib| destdir/lib }.join(':')
  end
end
