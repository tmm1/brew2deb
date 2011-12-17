require 'base'

class JRuby < Ruby
  homepage 'http://www.jruby.org/'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.6.5/jruby-bin-1.6.5.tar.gz', :as => 'jruby-1.6.5.tar.gz'
  md5 '54354082673bd115f945890dc6864413'

  source 'https://rubygems.org/downloads/jruby-launcher-1.0.9-java.gem'

  name 'rbenv-jruby-1.6.5'
  section 'interpreters'
  version '1.0.0'
  description 'The JRuby Ruby virtual machine'

  provides! 'rbenv-jruby'

  depends \
    'sun-java6-jre | default-jre'

  def build
    # Remove Windows files
    rm Dir['bin/*.{bat,dll,exe,sh}']
  end

  def install
    prefix.install Dir['*']
    ln_s 'jruby', prefix/'bin/ruby'
  end

  def post_install
    super

    install_gem builddir/'jruby-launcher-1.0.9-java.gem'
  end
end
