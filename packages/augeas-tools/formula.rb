class AugeasTools < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/main/a/augeas/augeas_0.8.1-2.dsc'
  md5 'b57393e8a6df54758c71bc89ca360c33'

  version '0.8.1-2'

  build_depends %w(chrpath naturaldocs texlive-latex-base)

  def package
    FileUtils.mkdir_p(HOMEBREW_WORKDIR+'pkg')
    Dir[HOMEBREW_WORKDIR+'tmp-build'+'*tools*.{dsc,gz,changes,deb,udeb}'].each do |file|
      FileUtils.cp file, HOMEBREW_WORKDIR+'pkg'
    end
  end
end