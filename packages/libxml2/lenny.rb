class Libxml2 < DebianSourceFormula
  url 'http://security.debian.org/debian-security/pool/updates/main/libx/libxml2/libxml2_2.7.8.dfsg-2+squeeze7.dsc'
  md5 '595067fbabf7626fd9ee9aebd8155949'

  def patches
    [
      'lennydeps.patch',
      'notests.patch',
      'nodocs.patch',
      'version.patch',
    ]
  end
end
