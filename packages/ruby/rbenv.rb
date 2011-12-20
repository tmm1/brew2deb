class Rbenv < DebianFormula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'git://github.com/sstephenson/rbenv', :tag => 'v0.2.1'

  name 'rbenv'
  version '0.2.1'
  section 'interpreters'
  description 'Simple Ruby version management'

  def build
    inreplace 'libexec/rbenv', 'RBENV_ROOT="${HOME}/.rbenv"', 'RBENV_ROOT="/usr/share/rbenv"'
    # inreplace 'libexec/rbenv-rehash', 'SHIM_PATH="${RBENV_ROOT}/shims"', 'SHIM_PATH="/usr/share/rbenv/shims"'
  end

  def install
    (share/'rbenv').install Dir['*'].sort.reverse
    (destdir/'usr/local/bin/rbenv').mkpath
    (prefix/'bin').mkpath
    ln_s '../share/rbenv/bin/rbenv', prefix/'bin/rbenv'
  end
end
