require 'formula'

class LinuxImage < DebianFormula
  url 'http://mirror.pnl.gov/ubuntu//pool/main/l/linux/linux-image-3.2.0-35-generic_3.2.0-35.55_amd64.deb'
  md5 'cd1a00401034c52310c1521d5656f9a3'
  source 'http://ftp.us.debian.org/debian/pool/main/l/linux-2.6/linux-image-2.6.32-5-amd64_2.6.32-46_amd64.deb'

  def build
    sh 'ar x linux-image-3.2.0-*.deb'
    sh 'mkdir -p pkg'
    sh 'cd pkg && tar jxf ../data.tar.bz2'
    sh 'ar x linux-image-2.6.32*.deb'
    sh 'mkdir -p pkg/DEBIAN'
    sh 'cd pkg/DEBIAN && tar zxf ../../control.tar.gz'
    sh 'sed -i "s/2.6.32-5-amd64/3.2.0-35-generic/g" pkg/DEBIAN/*'
    sh 'sed -i "s/Version: .*/Version: 3.2.0-35.55+github1/" pkg/DEBIAN/control'
    sh 'sed -i "s/2.6.32 /3.2.0 /" pkg/DEBIAN/control'
  end

  def install
  end

  def package
    sh 'dpkg -b pkg'
    sh 'mv pkg.deb ../linux-image-3.2.0-35-generic_3.2.0-35.55+github1_amd64.deb'
  end
end
