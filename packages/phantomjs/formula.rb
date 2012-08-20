class PhantomJS < DebianFormula
  homepage 'http://www.phantomjs.org/'
  url 'http://phantomjs.googlecode.com/files/phantomjs-1.6.1-linux-x86_64-dynamic.tar.bz2'
  md5 'fbfc540dd9abfa9dbbc75d942671eeaf'

  name 'phantomjs16'
  version '1.6.1+github1'
  section 'utilities'
  description 'headless webkit and shit'

  def configure
    # noop
  end

  def build
    # noop
  end

  def install
    build_prefix = workdir + 'tmp-build/phantomjs-1.6.1-linux-x86_64-dynamic'
    phantom_prefix = workdir + 'tmp-install/opt/phantomjs'

    system "mkdir -p #{phantom_prefix}"
    system "cp -r #{build_prefix}/bin #{phantom_prefix}"
    system "cp -r #{build_prefix}/lib #{phantom_prefix}"
  end
end
