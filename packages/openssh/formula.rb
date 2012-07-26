class OpenSSH < DebianSourceFormula
  url 'http://ftp.de.debian.org/debian-archive/debian/pool/main/o/openssh/openssh_5.1p1-5.dsc'
  md5 '338282d6bc34e9ea227862557a042818'
  version '1:5.1p1-5github7'

  def patches
    [
      'sjg-key-verification-plugin.patch',
      'sjg-ignore-mysql-options.patch',
    ]
  end
end
