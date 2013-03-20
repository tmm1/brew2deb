class Dset < DebianFormula
  url 'http://downloads.dell.com/FOLDER00925265M/1/dell-dset-3.3.0.300_x86.bin'
  md5 '69de5cdea5790c41d950b3918e06f472'
  name 'dell-dset'
  version '3.3.0.300+github1'

  build_depends \
    'rpm',
    'cpio'

  def build
    #lmao
  end

  def install
    bin_path = File.expand_path 'dell-dset-3.3.0.300_x86.bin' 

    chdir builddir do
      sh "tail -n+$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' #{bin_path}) #{bin_path} | tar xzv"
    end

    %w(
      rpms/dell-dset-common-3.3.0.300-1.i586.rpm
      rpms/dell-dset-collector-3.3.0.300-1.i586.rpm
      rpms/dell-dset-provider-3.3.0.300-1.i586.rpm
    ).each do |rpm|
      rpm_path = File.expand_path rpm
      chdir destdir do
        sh "rpm2cpio #{rpm_path} | cpio -d -i"
      end
    end
  end
end
