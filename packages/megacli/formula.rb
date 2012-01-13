class MegacliFormula < DebianFormula
  # download this manually (click through the EULA)
  url 'http://www.lsi.com/downloads/Public/MegaRAID%20Common%20Files/8.02.16_MegaCLI.zip'
  md5 '651f7250e0a64d94cafc08e4eb154740'

  name 'megacli'
  version '8.02.16'
  section 'alien'
  description 'MegaCli SAS RAID Management Utility.'

  build_depends \
    'rpm',
    'cpio',
    'unzip'

  def build
    chdir 'LINUX' do
      safe_system 'unzip', 'MegaCliLin.zip'
    end
  end

  def install
    %w[ Lib_Utils-1.00-09.noarch.rpm  MegaCli-8.02.16-1.i386.rpm ].each do |rpm|
      rpm_path = File.expand_path("LINUX/#{rpm}")
      chdir destdir do
        sh "rpm2cpio #{rpm_path} | cpio -d -i"
      end
    end

    mv destdir/'opt/MegaRAID/MegaCli/MegaCli', destdir/'opt/MegaRAID/MegaCli/MegaCli32'
  end
end
