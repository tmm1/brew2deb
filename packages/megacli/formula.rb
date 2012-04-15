class MegacliFormula < DebianFormula
  homepage 'http://www.lsi.com/support/products/Pages/MegaRAIDSAS8480E.aspx'
  # download this manually (click through the EULA)
  url 'http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/8.02.16_MegaCLI.zip'
  md5 '651f7250e0a64d94cafc08e4eb154740'

  name 'megacli'
  version '8.02.16+github1'
  section 'alien'
  description 'MegaCli SAS RAID Management Utility.'

  build_depends \
    'rpm',
    'cpio',
    'unzip'

  depends \
    'srvadmin-storelib-sysfs'

  def build
    chdir 'LINUX' do
      safe_system 'unzip', 'MegaCliLin.zip'
    end
  end

  def install
    rpm_path = File.expand_path("LINUX/MegaCli-8.02.16-1.i386.rpm")
    chdir destdir do
      sh "rpm2cpio #{rpm_path} | cpio -d -i"
    end

    mv destdir/'opt/MegaRAID/MegaCli/MegaCli', destdir/'opt/MegaRAID/MegaCli/MegaCli32'
  end
end
