class Nvm < DebianFormula
  homepage 'https://github.com/creationix/nvm'
  url 'git://github.com/creationix/nvm', :sha => '5a17b8'

  name 'nvm'
  version '1.0.0-5a17b8'
  section 'interpreters'
  description 'Simple node version management'

  def build
  end

  def install
    (share/'nvm').install Dir['*'].sort.reverse
  end
end
