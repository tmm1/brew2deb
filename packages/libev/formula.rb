class Libev < DebianFormula
  homepage 'http://software.schmorp.de/pkg/libev.html'
  url 'http://dist.schmorp.de/libev/libev-4.11.tar.gz'
  md5 'cda69b858a1849dfe6ce17c930cf10cd'

  name 'libev'
  version '4.11'
  section 'libs'
  description 'libev: high-performance event loop'

  conflicts 'libev-dev', 'libev3'

  def build
    configure :prefix => prefix 
    make
  end
end
