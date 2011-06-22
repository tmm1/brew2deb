class RubyRBX < DebianFormula
  homepage 'http://rubini.us/'
  url 'http://asset.rubini.us/rubinius-1.2.3-20110315.tar.gz', :as => 'rubinius-1.2.3.tar.gz'
  md5 '9782dab18c2dd440af6b76e8eb5bc0f0'

  name 'ruby-rbx'
  section 'interpreters'
  version '1.2.3'
  description 'The Rubinius Ruby virtual machine'

  def build
    configure :prefix => prefix, :skip_system => true
    sh 'rake', 'build'
  end

  def install
    ENV['FAKEROOT'] = destdir
    sh 'rake', 'install'
  end
end
