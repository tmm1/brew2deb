class GeoIPCityDB < DebianFormula
  VERSION = "GeoIP-133_20120327"

  homepage 'http://www.maxmind.com/app/city'
  url "#{VERSION}.tar.gz"
  md5 '100f82fea1a6a12d5e8494dcb8c13305'

  name 'geoip-city'
  version VERSION.sub('GeoIP-','').gsub('_','.') + '+github1'
  description 'City Database for use with the GeoIP library'

  depends 'libgeoip-dev', 'libgeoip1'

  def build
  end

  def install
    (share/'GeoIP').mkpath
    (share/'GeoIP').install "../#{VERSION}"
    (share/'GeoIP/GeoIPCity.dat').make_relative_symlink(share/"GeoIP/#{VERSION}/GeoIPCity.dat")
  end
end
