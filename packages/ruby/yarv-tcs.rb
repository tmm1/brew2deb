require 'yarv'

class TCS < YARV
  url 'git://github.com/thecodeshop/ruby', :sha => 'origin/tcs-ruby_1_9_3'
  homepage 'https://github.com/thecodeshop/ruby/wiki'

  source 'https://rubygems.org/downloads/bundler-1.2.0.rc.gem'

  name 'rbenv-1.9.3-p194+tcs'
  section 'interpreters'
  version '1.0.0'
  description 'The YARV Ruby virtual machine + TCS patches'

  provides! 'rbenv-1.9', 'rbenv-1.9.3'

  def build
    sh 'autoconf'
    super
  end
end
