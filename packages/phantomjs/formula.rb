class PhantomJS < DebianFormula
  homepage 'http://www.phantomjs.org/'
  url 'https://phantomjs.googlecode.com/files/phantomjs-1.7.0-source.zip'
  md5 'f2cf1d9e98dfb84c159748d34dea5f82'

  name 'phantomjs'
  version '1.7.0+github2'
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
      bin.install Dir['phantomjs-1.7.0-*/bin/phantomjs.bin']
      (share/'phantomjs/lib').mkpath
      (share/'phantomjs/lib').install Dir['phantomjs-1.7.0-*/lib/libQ*']
    end
  end
end
