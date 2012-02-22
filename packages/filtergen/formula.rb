class Filtergen < DebianFormula
  homepage 'http://packages.debian.org/squeeze/filtergen'
  url 'https://github.com/anchor/filtergen.git', :sha => 'b5a4b06'

  name 'filtergen'
  version '0.12.5+github1'
  description 'packet filter generator for various firewall systems'
  section 'net'

  build_depends \
    'flex',
    'bison',
    'autoconf',
    'automake'

  config_files \
    '/etc/filtergen/fgadm.conf',
    '/etc/filtergen/rules.filter'

  def build
    ENV['CFLAGS'] = '-O0 -ggdb'

    sh 'aclocal'
    sh 'autoconf'
    sh 'autoheader'
    sh 'automake --add-missing'

    configure :prefix => prefix, :sysconfdir => '/etc/filtergen'
    make
  end
end
