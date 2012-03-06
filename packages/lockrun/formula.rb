class Lockrun < DebianFormula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'https://raw.github.com/gist/17e978b7af98d0a112c8/b23c8799c75ea504f5162e47be920a045c45242d/lockrun.c', :get => :curl
  md5 '01b76b803fc8d0e9031cf06d0b06a809'

  name 'lockrun'
  version '1.0+github2'
  description 'Run cron job with overrun protection'

  def build
    sh("gcc lockrun.c -o lockrun")
  end

  def install
    bin.install "lockrun"
  end

  def stage
    if skip_build
      chdir(builddir) do
        yield
      end
    else
      super do
        download_extra_sources
        yield
      end
    end
  end
end
