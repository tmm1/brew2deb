class GeoIPCityDB < DebianFormula
  EDITION = "133"
  DATE    = '20120327'
  LICENSE = 'WxlMSJQFXkqF'
  VERSION = "GeoIP-#{EDITION}_#{DATE}"

  homepage 'http://www.maxmind.com/app/city'
  url "http://download.maxmind.com/app/geoip_download?edition_id=#{EDITION}&date=#{DATE}&suffix=tar.gz&license_key=#{LICENSE}"
  md5 '100f82fea1a6a12d5e8494dcb8c13305'

  name 'geoip-city'
  version "#{EDITION}.#{DATE}+github1"
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
