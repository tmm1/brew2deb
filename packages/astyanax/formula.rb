class Astyanax < DebianFormula
  homepage 'https://github.com/Netflix/astyanax/'
  url 'http://s3.amazonaws.com/github-packages/astyanax-1.0.4-monolithic.jar', :using => :nounzip
  md5 'f7e1a915117d7b6bb4288c46ad61c69c'

  name 'astyanax'
  version '1.0.4'
  section 'utilities'
  description 'a pure Java client library for Cassandra'

  depends \
    'sun-java6-jre'

  def build
    # noop
  end

  def install
    base = Pathname.new(@url).basename

    home = share/'astyanax'
    home.install base
    (home/'astyanax.jar').make_relative_symlink(home/"#{base}")
  end
end
