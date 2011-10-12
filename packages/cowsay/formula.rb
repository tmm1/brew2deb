class Cowsay < DebianFormula
  url 'http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz'
  homepage 'http://www.nog.net/~tony/warez/cowsay.shtml'
  md5 'b29169797359420dadb998079021a494'

  name    'cowsay'
  version '3.03+github1'

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix+'man', share
  end

  def configure(*) ; end
  def make(*) ; end
end
