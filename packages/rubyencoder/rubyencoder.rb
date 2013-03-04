class RubyEncoder < DebianFormula
  def self.encoder_version(version)
    plain_version = version.sub('.', '')

    self.url "https://github-enterprise.s3.amazonaws.com/util/rubyencoder-#{version}-linux.tar.gz"
    self.name "rubyencoder#{plain_version}"
    self.version "#{version}+github1"
  end

  arch 'x86_64'
  shared_deps false

  depends \
    'libgphoto2-2',
    'libsane',
    'ia32-libs-multiarch',
    'ia32-libs'

  def build
  end

  def install
    name = self.class.name

    prefix.install Dir['*']
    ln_s((prefix / 'bin/rubyencoder'), (bin / name))
  end
end
