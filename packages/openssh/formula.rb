class OpenSSH < DebianSourceFormula
  url 'http://www.emdebian.org/grip/pool/main/o/openssh/openssh_5.1p1-5.dsc'
  md5 '338282d6bc34e9ea227862557a042818'
  version '1:5.1p1-5github3'

  def patches
    [
      'mysql_patch_5.2-p1-1.patch',
      'enable_mysql_keys.patch',
    ]
  end
end
