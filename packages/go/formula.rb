require 'formula'

class Go < DebianFormula
  homepage 'http://www.golang.org'
  url 'https://go.googlecode.com/files/go1.0.3.linux-amd64.tar.gz'
  sha1 '97299d1989936b90d0c51ec8028d1f5dca8df6b6'

  name 'go'
  version '1.0.3'
  section 'main'
  description 'An open source programming environment from Google'

  def build
  end

  def install
    system "mkdir -p #{destdir}/usr/local #{destdir}/usr/bin"
    system "cd .. && mv go #{destdir}/usr/local/"
    system "ln -s /usr/local/go/bin/go    #{destdir}/usr/bin/"
    system "ln -s /usr/local/go/bin/gofmt #{destdir}/usr/bin/"
    system "ln -s /usr/local/go/bin/godoc #{destdir}/usr/bin/"
  end
end
