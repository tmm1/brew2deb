class Freight < DebianFormula
  homepage 'http://rcrowley.github.com/freight/'
  url 'https://github.com/rcrowley/freight.git', :tag => 'v0.0.9'

  arch 'all'
  name 'freight'
  section 'admin'
  version '0.0.9+github1'
  description 'A modern take on the Debian archive'

  depends \
    'coreutils',
    'bash | dash',
    'dpkg',
    'gnupg',
    'grep'

  config_files '/etc/freight.conf'

  def build
  end

  def install
    make :install,
      'DESTDIR' => destdir,
      'prefix' => '/usr',
      'sysconfdir' => '/etc'

    mv etc/'freight.conf.example', etc/'freight.conf'

    %w(lib cache).each do |dir|
      (var/dir/'freight').mkpath
    end
  end
end
