class Lockrun < DebianFormula
  homepage 'https://github.com/jakedouglas/lockrun/blob/784e3339ec0f9d205a79ff9b3091e1b1add1272b/README.markdown'
  url 'https://raw.github.com/jakedouglas/lockrun/784e3339ec0f9d205a79ff9b3091e1b1add1272b/lockrun.c', :get => :curl
  md5 '0aeb2b56edac70178a48f57ef5602f09'

  name 'lockrun'
  version '1.0+github4'
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
