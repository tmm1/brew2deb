class SyscfgFormula < DebianFormula
  url 'http://linux.dell.com/repo/hardware/latest/platform_independent/rh60_64/DTK/syscfg-4.2.0-4.604.1.el6.x86_64.rpm'

  name 'dell-syscfg'
  version '4.2.0-4.604.1+github1'
  section 'alien'
  description 'Manage your BIOS. Do it live!'

  build_depends \
    'rpm',
    'cpio'

  def build
    #lmao
  end

  def install
    rpm_path = File.expand_path 'syscfg-4.2.0-4.604.1.el6.x86_64.rpm'

    chdir destdir do
      sh "rpm2cpio #{rpm_path} | cpio -d -i"
    end
  end
end
