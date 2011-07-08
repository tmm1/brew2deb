class Freight < DebianFormula
  homepage 'http://rcrowley.github.com/freight/'
  url 'https://github.com/rcrowley/freight.git', :sha => '4745231'

  arch 'all'
  name 'freight'
  section 'admin'
  version '0.0.7+github1'
  description 'A modern take on the Debian archive'

  conffiles '/etc/freight.conf'

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
