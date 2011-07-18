class Wget < DebianSourceFormula
  url 'http://ftp.de.debian.org/debian/pool/main/w/wget/wget_1.12-3.1.dsc'
  md5 '58444c360b9977e2e8bf00bcec3d93bf'

  version '1.12-3.1+github1'

  def patches
    # Fixes annoying TLS Subject Alternative Name bug encountered especially when using GitHub
    # See https://savannah.gnu.org/bugs/?23934
    "http://savannah.gnu.org/file/wget-1.12-subjectAltNames.diff?file_id=18828"
  end
end
