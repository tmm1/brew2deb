class RubyEncoder < DebianFormula
  attr_rw :package_name

  def self.encoder_version(version)
    plain_version = version.sub('.', '')

    self.package_name "rubyencoder-#{version}"
    self.url "https://github-enterprise.s3.amazonaws.com/util/#{package_name}-linux.tar.gz"
    self.name "rubyencoder#{plain_version}"
    self.version "#{version}+github1"
  end

  arch 'x86_64'

  depends \
    'libgphoto2-2',
    'libsane',
    'ia32-libs-multiarch',
    'ia32-libs'

  def build
  end

  def install
    package_name = self.class.package_name

    local = prefix / 'local'
    package_path = local / package_name
    package_path.mkpath

    FileUtils.cp_r 'bin', package_path
  end
end
