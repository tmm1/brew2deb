class Lsof < DebianFormula
  homepage 'http://people.freebsd.org/~abe/'
  url 'ftp://lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.85.tar.gz'
  md5 'e8151db708a023f588a3591da55a0a29'

  name 'lsof'
  version '4.85'
  section ''
  description 'lists information about files that are open by the processes running on a UNIX system'

  def build
    sh 'tar xf lsof_4.85_src.tar'
    chdir 'lsof_4.85_src' do
      sh './Configure', '-n', 'linux'
      make
    end
  end

  def install
    bin.install 'lsof_4.85_src/lsof'
    man8.install 'lsof_4.85_src/lsof.8'
    sh 'gzip', man8/'lsof.8'
  end
end
