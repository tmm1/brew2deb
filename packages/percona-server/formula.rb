class PerconaServer < DebianSourceFormula
  url 'http://www.percona.com/downloads/Percona-Server-5.5/Percona-Server-5.5.17-22.1/deb/lenny/x86_64/percona-server-5.5_5.5.17-rel22.1-197.lenny.dsc'
  md5 '4284e73bb104297a8dbdedeb3f059700'

  version '5.5.17-rel22.1-197.lenny+github1'

  build_depends 'libaio-dev'

  def package
    FileUtils.mkdir_p(HOMEBREW_WORKDIR+'pkg')
    Dir[HOMEBREW_WORKDIR+'tmp-build'+'*.deb'].each do |file|
      safe_system HOMEBREW_WORKDIR+'stripdeb.sh', file
    end
    Dir[HOMEBREW_WORKDIR+'tmp-build'+'*.{dsc,gz,changes,deb,udeb}'].each do |file|
      FileUtils.cp file, HOMEBREW_WORKDIR+'pkg'
    end
  end
end
