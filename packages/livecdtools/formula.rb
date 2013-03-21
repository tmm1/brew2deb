class Livecdtools < DebianFormula
  url 'https://projects.centos.org/svn/livecd/trunk/CentOS6/x86_64/RPMS/livecd-tools-0.3.5-2.x86_64.rpm'
  md5 '787058e9a65a6b379a3bad20b30ccc1e'

  name 'livecd-tools'
  version '0.3.5-2+github1'
  section 'alien'

  build_depends \
    'rpm',
    'cpio'

  def build
    #lmao
  end

  def install
    rpm_path = File.expand_path 'livecd-tools-0.3.5-2.x86_64.rpm'

    chdir destdir do
      sh "rpm2cpio #{rpm_path} | cpio -d -i"
    end
  end
end
