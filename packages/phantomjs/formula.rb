class PhantomJS < DebianFormula
  homepage 'http://www.phantomjs.org/'
  url 'https://phantomjs.googlecode.com/files/phantomjs-1.6.1-source.zip'
  md5 'd169130eb9e7b483e6d3e927be07c8b3'

  name 'phantomjs'
  version '1.6.1+github2'
  section 'utilities'
  description 'headless webkit and shit'

  build_depends 'libfontconfig1-dev'

  replaces 'phantomjs16'
  provides 'phantomjs16'
  conflicts 'phantomjs16'

  def build
    sh './build.sh --jobs 1'
  end

  def install
    chdir 'deploy' do
      sh './package.sh --bundle-libs'
      bin.install workdir/'phantomjs'
      bin.install Dir['phantomjs-1.6.1-*/bin/phantomjs.bin']
      (share/'phantomjs/lib').mkpath
      (share/'phantomjs/lib').install Dir['phantomjs-1.6.1-*/lib/libQ*']
    end
  end
end
