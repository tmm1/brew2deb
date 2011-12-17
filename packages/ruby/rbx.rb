require 'base'

class Rubinius < Ruby
  homepage 'http://rubini.us/'
  url 'http://asset.rubini.us/rubinius-1.2.4-20110705.tar.gz', :as => 'rubinius-1.2.4.tar.gz'
  md5 '403c777d19b3553e9cb36701fe002c5e'

  name 'rbenv-rbx-1.2.4'
  section 'interpreters'
  version '1.0.0'
  description 'The Rubinius Ruby virtual machine'

  provides! 'rbenv-rbx'

  def build
    configure :prefix => prefix, :skip_system => true
    sh 'rake', 'build'
  end

  def install
    prefix.mkpath
    ENV['FAKEROOT'] = destdir
    sh 'rake', 'install'
  end

  def install_rubygems
    # bundled with rbx
  end
  alias install_rake install_rubygems

  def install_bundler
    # not working =(
  end

  # def rubylib
  #   ENV['RUBYLIB'] = prefix/'lib'
  #   ENV['RBX_RUNTIME'] = prefix/'runtime'
  #   super
  # end

  # def install_gem(name)
  #   sh prefix/'bin/rbx', '-S', 'gem', 'install', '--no-ri', '--no-rdoc', name
  # end
end
