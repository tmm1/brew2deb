require 'formula'

class Igb < DebianFormula
  url 'https://github.com/github/igb.git', :sha => 'dbac09b5be22b59053bc790ab136e0c1c983e679'

  name 'igb'
  version '3.4.8+github1'
  section 'main'
  description 'GitHub\'s custom brewed Intel igb driver. Tastes like peaches.'

  def build
    system "cd src && make"
  end

  def install
    system "mkdir -p #{destdir}/lib/modules/2.6.32-5-amd64/updates/kernel/drivers/net/igb"
    system "cp src/*.ko #{destdir}/lib/modules/2.6.32-5-amd64/updates/kernel/drivers/net/igb/"
  end

  def postinst
    "
      #!/bin/sh
      set -e
      
      update-initramfs -u -k 2.6.32-5-amd64
    ".ui
  end
end

