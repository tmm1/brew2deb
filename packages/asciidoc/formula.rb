class AsciiDoc < DebianSourceFormula
  url 'http://archive.debian.org/debian-backports/pool/main/a/asciidoc/asciidoc_8.4.4-1~bpo50+1.dsc'
  md5 '75db77d7ed1064dc8e28c1c8d0caaeeb'

  version '8.4.4-1~bpo50+1+github1'

  def patches
    'eval-security-fix.patch'
  end
end
