require 'formula'

class Megaraid_sas < DebianFormula
  url 'https://github.com/github/megaraid_sas.git', :sha => 'e6ba9b612eb7a6ddd5e76f7f8b940b95b2718d77'

  name 'megaraid-sas'
  version '5.39+github1'
  section 'main'
  description 'GitHub\'s custom brewed MegaRAID SAS driver. Tastes like strawberries.'

  depends \
    'linux-image-2.6.32-5-amd64',
    'initramfs-tools'

  def build
    system "patch -p1 < patches/sles11-sp1.patch"
    system "make PWD=`pwd` -f Makefile.standalone"
  end

  def install
    system "mkdir -p #{destdir}/lib/modules/2.6.32-5-amd64/updates/kernel/drivers/scsi/megaraid/"
    system "cp *.ko #{destdir}/lib/modules/2.6.32-5-amd64/updates/kernel/drivers/scsi/megaraid/"
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
