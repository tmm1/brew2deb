class DellDTKScriptsFormula < DebianFormula
  url 'http://linux.dell.com/repo/hardware/latest/platform_independent/rh60_64/DTK/dtk-scripts-4.2.0-4.10.1.el6.x86_64.rpm'

  name 'dell-dtk-scripts'
  version '4.2.0-4.10.1+github1'
  section 'alien'
  description 'Dell DTK scripts for managing your hardware'

  build_depends \
    'rpm',
    'cpio'

  def build
    #lmao
  end

  def install
    rpm_path = File.expand_path 'dtk-scripts-4.2.0-4.10.1.el6.x86_64.rpm'

    chdir destdir do
      sh "rpm2cpio #{rpm_path} | cpio -d -i"
    end
  end
end


