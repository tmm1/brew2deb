require 'mri'

class YARV < MRI
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 '8e2fef56185cfbaf29d0c8329fc77c05'

  name 'rbenv-1.9.3-p0'
  section 'interpreters'
  version '1.0.0'
  description 'The YARV Ruby virtual machine'

  provides! 'rbenv-1.9', 'rbenv-1.9.3'

  build_depends \
    'libyaml-dev'

  depends \
    'libyaml-0-1'

  def configure(opts={})
    super opts.merge(:disable_install_rdoc => true)
  end

  def install_rubygems
    # bundled with 1.9
  end
  alias install_rake install_rubygems

  def rubylib
    `strings #{prefix/'bin/ruby'}`.split("\n").grep(/versions/).grep(/lib/).map{ |lib| destdir/lib }.join(':')
  end
end
