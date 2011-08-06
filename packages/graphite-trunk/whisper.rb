class Whisper < DebianFormula
  homepage 'http://launchpad.net/graphite'
  url 'https://github.com/tmm1/graphite.git', :tag => '60287e0'

  arch 'all'
  name 'whisper'
  version '0.9.9-pre2'
  section 'python'
  description 'database engine for fast, reliable fixed-sized databases'

  build_depends 'python'
  depends 'python', 'python-rrdtool'
  conflicts 'python-whisper'

  def build
    chdir 'whisper' do
      sh 'python', 'setup.py', 'build'
    end
  end

  def install
    chdir 'whisper' do
      sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"

      Dir[prefix/'bin/*.py'].each do |path|
        mv path, path.gsub(/\.py$/,'')
      end
    end
  end
end
