class Lockrun < DebianFormula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'https://raw.github.com/gist/17e978b7af98d0a112c8/ecd942eb9e40272b98f502eaf5af25b002d7a616/lockrun.c', :get => :curl
  md5 '2fbcc5899767e0fb1d62302d4478dc16'

  name 'lockrun'
  version '1.0+github1'
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
