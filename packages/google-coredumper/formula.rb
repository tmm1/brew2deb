class Coredumper < DebianFormula
  homepage 'http://code.google.com/p/google-coredumper/'
  url 'http://google-coredumper.googlecode.com/files/coredumper-1.2.1.tar.gz'
  md5 '05b88bb36c4ba41df4c7d99169b795eb'

  name 'google-coredumper'
  version '1.2.1'
  description 'A neat tool for creating GDB readable coredumps from multithreaded applications'

  conflicts 'libcoredumper-dev', 'libcoredumper', 'libcoredumper1'
  replaces 'libcoredumper-dev', 'libcoredumper', 'libcoredumper1'
  provides 'libcoredumper-dev', 'libcoredumper', 'libcoredumper1'

  def build
    configure :prefix => prefix, :mandir => prefix/'share/man'
    make
  end
end
