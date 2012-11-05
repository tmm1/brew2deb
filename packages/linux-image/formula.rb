require 'formula'

class LinuxImage < DebianFormula
  url 'http://mirror.pnl.gov/ubuntu//pool/main/l/linux/linux-image-3.5.0-17-generic_3.5.0-17.28_amd64.deb'
  md5 '957b98e7d921beb3d3f35cbdac827e3c'
  source 'http://mirror.pnl.gov/ubuntu//pool/main/l/linux/linux-image-extra-3.5.0-17-generic_3.5.0-17.28_amd64.deb'
  source 'http://ftp.us.debian.org/debian/pool/main/l/linux-2.6/linux-image-2.6.32-5-amd64_2.6.32-46_amd64.deb'

  def build
    sh 'ar x linux-image-3.5.0-*.deb'
    sh 'mkdir -p pkg'
    sh 'cd pkg && tar jxf ../data.tar.bz2'
    sh 'ar x linux-image-extra-3.5.0*.deb'
    sh 'cd pkg && tar jxf ../data.tar.bz2'
    sh 'ar x linux-image-2.6.32*.deb'
    sh 'mkdir -p pkg/DEBIAN'
    sh 'cd pkg/DEBIAN && tar zxf ../../control.tar.gz'
    sh 'sed -i "s/2.6.32-5-amd64/3.5.0-17-generic/g" pkg/DEBIAN/*'
    sh 'sed -i "s/Version: .*/Version: 3.5.0.17.28+github1/" pkg/DEBIAN/control'
    sh 'sed -i "s/2.6.32 /3.5.0 /" pkg/DEBIAN/control'
  end

  def install
  end

  def package
    sh 'dpkg -b pkg'
    sh 'mv pkg.deb ../linux-image-3.5.0-17-generic_3.5.0-17.28+github1_amd64.deb'
  end
end
