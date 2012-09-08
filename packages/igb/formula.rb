require 'formula'

class Igb < DebianFormula
  url 'https://github.com/github/igb.git', :sha => 'dbac09b5be22b59053bc790ab136e0c1c983e679'

  name 'igb'
  version '3.4.8+github4'
  section 'main'
  description 'GitHub\'s custom brewed Intel igb driver. Tastes like peaches.'

  depends \
    'linux-image-2.6.32-5-amd64',
    'initramfs-tools'

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

      /sbin/depmod -a      
      /usr/sbin/update-initramfs -u -k all
    ".ui
  end
end

