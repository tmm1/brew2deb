class Freight < DebianFormula
  homepage 'http://rcrowley.github.com/freight/'
  url 'https://github.com/rcrowley/freight.git', :sha => '3e4c347'

  arch 'all'
  name 'freight'
  section 'admin'
  version '0.0.9+github2'
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

    inreplace etc/'freight.conf' do |s|
      s.gsub! 'example@example.com', 'support@github.com'
      s << 'GNUPGHOME="/etc/freight/keys"'
      s << "\n\nexport GNUPGHOME"
    end

    %w(lib cache).each do |dir|
      (var/dir/'freight').mkpath
    end

    %w(bash_completion.d profile.d).each do |dir|
      rm_rf etc/dir
    end

    (etc/'freight/keys').mkpath
    chmod 0700, etc/'freight/keys'
  end
end
