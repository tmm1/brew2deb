class Facter < DebianFormula
  url 'https://github.com/jfryman/massive-octo-bear.git'

  name 'facter-dummy'
  version '1.6.18'
  description "Empty dummy package for facter"

  provides "facter"

  def build
  end

  def install
  end
end
