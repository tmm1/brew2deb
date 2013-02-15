class Augeas < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/main/a/augeas/augeas_0.8.1-2.dsc'
  md5 'b57393e8a6df54758c71bc89ca360c33'

  version '0.8.1-2'

  build_depends %w(chrpath naturaldocs texlive-latex-base)
end