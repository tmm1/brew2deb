class Whisper < DebianFormula
  url 'http://launchpad.net/graphite/1.0/0.9.8/+download/whisper-0.9.8.tar.gz'
  md5 'c5f291bfd2d7da96b524b8423ffbdc68'

  arch 'all'
  name 'whisper'
  version '0.9.8'
  section 'python'
  description 'database engine for fast, reliable fixed-sized databases'

  build_depends 'python'
  depends 'python', 'python-rrdtool'
  conflicts 'python-whisper'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"

    Dir[prefix/'bin/*.py'].each do |path|
      mv path, path.gsub(/\.py$/,'')
    end
  end
end
