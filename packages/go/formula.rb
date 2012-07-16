require 'formula'

class Go < DebianFormula
  homepage 'http://www.golang.org'
  url 'http://go.googlecode.com/files/go1.0.2.linux-amd64.tar.gz'
  md5 'db580c82eeb15fd98b6eb4afd1055459'

  name 'go'
  version '1.0.2'
  section 'main'
  description 'An open source programming environment from Google'

  def build
  end

  def install
    system "mkdir -p #{destdir}/local"
    system "cd .. && mv go #{destdir}/local/"
  end
end
