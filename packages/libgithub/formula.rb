class Libgithub < DebianFormula
  homepage 'https://github.com/github/libgithub'
  url 'git@github.com:github/libgithub', :sha => 'bb37a5777750fbb126d8c6249ad4a26fba968056'

  name 'libgithub'
  version "1.0.3"
  section 'libs'
  description 'Utility library for writing C at GitHub'

  def build
    system 'make'
  end

  def install
    system "make PREFIX=#{prefix} install"
  end
end
