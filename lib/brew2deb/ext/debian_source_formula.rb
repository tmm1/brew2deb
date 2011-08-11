class DebianSourceFormula < DebianFormula
  build_depends \
    'fakeroot',
    'devscripts',
    'dpkg-dev'

  def build
    ENV['DEBEMAIL'] = maintainer
    if ver = self.class.version
      safe_system 'dch', '-v', ver, 'brew2deb package'
    end
    safe_system 'dpkg-buildpackage', '-rfakeroot', '-us', '-uc'
  end

  def install
  end

  def package
    FileUtils.mkdir_p(pkgdir+'pkg')
    Dir[builddir+'*.{dsc,gz,changes,deb,udeb}'].each do |file|
      FileUtils.cp file, pkgdir
    end
  end
end
