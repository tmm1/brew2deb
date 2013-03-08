class MegacliFormula < DebianFormula
  homepage 'http://www.lsi.com/support/products/Pages/MegaRAIDSAS8480E.aspx'
  url 'https://s3.amazonaws.com/breakin-deps/8.07.06_MegaCLI.zip'

  name 'megacli'
  version '8.07.06+github1'
  section 'alien'
  description 'MegaCli SAS RAID Management Utility.'

  build_depends \
    'rpm',
    'cpio',
    'unzip'

  depends \
    'srvadmin-storelib-sysfs'

  def build
    #lmao
  end

  def install
    rpm_path = File.expand_path("Linux/MegaCli-8.07.06-1.noarch.rpm")
    chdir destdir do
      sh "rpm2cpio #{rpm_path} | cpio -d -i"
    end

    mv destdir/'opt/MegaRAID/MegaCli/MegaCli', destdir/'opt/MegaRAID/MegaCli/MegaCli32'
  end
end
