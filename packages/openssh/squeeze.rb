require './formula'

class OpenSSH
  url 'http://ftp.de.debian.org/debian/pool/main/o/openssh/openssh_5.5p1-6+squeeze1.dsc'
  md5 'b674c09fe06caa7b7735d05780813ae6'
  version '1:5.5p1-6+squeeze1+github5'

  def patches
    [
      'mysql_patch_5.5-p1-1.patch',
      'squeeze-enable_mysql_keys.patch',
      'mysql_connect_retry.patch',
    ]
  end
end
