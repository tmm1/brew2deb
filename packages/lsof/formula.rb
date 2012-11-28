class Lsof < DebianFormula
  homepage 'http://people.freebsd.org/~abe/'
  url 'ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.86.tar.gz'
  md5 '825e48436ab6b66607528a8640a41287'

  name 'lsof'
  version '4.86'
  section ''
  description 'lists information about files that are open by the processes running on a UNIX system'

  def build
    sh 'tar xf lsof_4.86_src.tar'
    chdir 'lsof_4.86_src' do
      sh './Configure', '-n', 'linux'
      make
    end
  end

  def install
    bin.install 'lsof_4.86_src/lsof'
    man8.install 'lsof_4.86_src/lsof.8'
    sh 'gzip', man8/'lsof.8'
  end
end
