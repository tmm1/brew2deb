class Libgithub < DebianFormula
  homepage 'https://github.com/github/libgithub'
  url 'git@github.com:github/libgithub', :sha => '7735b20'

  name 'libgithub'
  version "1.0.1"
  section 'libs'
  description 'Utility library for writing C at GitHub'

  def build
    system 'make'
  end

  def install
    system "make PREFIX=#{prefix} install"
  end
end
