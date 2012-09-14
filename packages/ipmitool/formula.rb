class Ipmitool < DebianSourceFormula
  url 'http://ftp.us.debian.org/debian/pool/main/i/ipmitool/ipmitool_1.8.11-2%2bsqueeze2.dsc'
  md5 '09af621016c76a71e2b1f4d670bcac11'

  version '1.8.11-2+squeeze2+github1'

  def patches
    '0001-Disable-asserts.patch'
  end
end
