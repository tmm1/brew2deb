class Dhcping < DebianFormula
  homepage 'http://www.mavetju.org/unix/dhcping-man.php'
  url 'http://www.mavetju.org/download/dhcping-1.2.tar.gz'
  md5 'c4b22bbf3446c8567e371c40aa552d5d'

  name 'dhcping'
  version '1.2'

  def build
    configure :prefix => prefix, :bindir => sbin

    make
  end

  def install
    make :install
  end
end
