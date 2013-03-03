class Smartmontools < DebianFormula
  url 'https://smartmontools.svn.sourceforge.net/svnroot/smartmontools/trunk/smartmontools', :revision => '3783'
  name 'smartmontools'
  version '6.1-0github1+r3783'
  build_depends %w(subversion quilt libcap-ng-dev)

  def build
    sh './autogen.sh'
    configure :sysconfdir => '/etc', :prefix => '/usr'
    make
  end
end
