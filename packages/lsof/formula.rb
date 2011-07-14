class Lsof < DebianFormula
  homepage 'http://people.freebsd.org/~abe/'
  url 'ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.84.tar.gz'
  md5 '6dae655988c810a7042c06a4e2fa3c5f'

  name 'lsof'
  version '4.84'
  section ''
  description 'lists information about files that are open by the processes running on a UNIX system'

  def build
    sh 'tar xf lsof_4.84_src.tar'
    chdir 'lsof_4.84_src' do
      sh './Configure', '-n', 'linux'
      make
    end
  end

  def install
    bin.install 'lsof_4.84_src/lsof'
    man8.install 'lsof_4.84_src/lsof.8'
    sh 'gzip', man8/'lsof.8'
  end
end
