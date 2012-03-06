class Lockrun < DebianFormula
  homepage 'http://unixwiz.net/tools/lockrun.html'
  url 'https://raw.github.com/gist/17e978b7af98d0a112c8/eba757278acb425c0157d5d781f48a801905e7dc/lockrun.c', :get => :curl
  md5 '7670ecfd1f9bf79462baed43e27af12f'

  name 'lockrun'
  version '1.0+github3'
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
