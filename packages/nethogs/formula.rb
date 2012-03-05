class Nethogs < DebianFormula
  homepage 'http://nethogs.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/nethogs/nethogs/0.8/nethogs-0.8.0.tar.gz'
  md5 'd6fb12b46e80a50c9b9f91dd48e2b234'

  name 'nethogs'
  version '0.8.0'
  description "a small 'net top' tool"
  section 'utils'

  build_depends \
    'libpcap0.8-dev',
    'libncurses5-dev | libncurses6-dev'

  def build
    make
  end
end
