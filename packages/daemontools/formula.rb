class Daemontools < DebianSourceFormula
  url 'http://ftp.de.debian.org/debian/pool/main/d/daemontools/daemontools_0.76-3.dsc'
  md5 '387fa6143b512f0b6a0e53b73b147713'
  version '1:0.76-3+github1'

  # http://debian.2.n7.nabble.com/Bug-568092-daemontools-support-QUIT-USR-12-signals-td267511.html
  def patches
    'daemontools_sigq12.patch'
  end
end
