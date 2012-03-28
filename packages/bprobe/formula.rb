class BProbe < DebianFormula
  homepage 'https://boundary.com/'
  url 'https://downloads.boundary.com/source/bprobe-1.0.0fi736.tar.gz'
  md5 '0fddff2144c8e2c91b54f71c71dd568c'

  source 'http://www.tcpdump.org/release/libpcap-1.2.1.tar.gz'
  source 'http://google-coredumper.googlecode.com/files/coredumper-1.2.1.tar.gz'
  source 'http://download.savannah.gnu.org/releases/libunwind/libunwind-1.0.1.tar.gz'

  name 'bprobe'
  version '1.0.0-1fi736'
  description 'boundary IPFIX flow meter'
  section 'net'

  build_depends 'autoconf', 'automake', 'autotools-dev', 'libtool', 'libssl-dev'
  config_files '/etc/default/bprobe', '/etc/bprobe/bprobe.defaults'

  def patches
    'disable-shlib-deps.patch'
  end

  def build
    ENV['CFLAGS'] = '-fPIC'

    build_pcap        unless File.exists?(pcap_root)
    build_coredumper  unless File.exists?(coredumper_root)
    build_libunwind   unless File.exists?(unwind_root)

    build_bprobe
  end

  def build_bprobe
    ENV['CFLAGS']  = "-ggdb3 -I#{pcap_root}/include -I#{unwind_root}/include -I#{coredumper_root}/include"
    ENV['LDFLAGS'] = "-Wl,-z,norelro -L#{unwind_root}/lib -L#{coredumper_root}/lib"

    sh './autogen.sh --noconfig'
    configure \
      :prefix => prefix,
      :with_openssl => true,
      :with_pcap_root => pcap_root,
      :with_libcoredumper => true,
      :with_libunwind => true
    make
  end

  def install
    super

    FileUtils.rm_rf (lib/'nprobe').to_s

    (etc/'bprobe').install ['scripts/cert/ca.pem', 'scripts/bprobe.defaults']
    (etc/'init.d').install_p 'scripts/debian/bprobe'
    (share/'bprobe').install Dir['scripts/*.sh']

    (etc/'default').mkpath
    File.open(etc/'default/bprobe', 'w'){ |f| f.puts 'INTERFACES=' }

    (destdir/'usr/local/bin').mkpath
    (destdir/'usr/local/bin/bprobe').make_relative_symlink bin/'bprobe'
  end

  ##
  # static library dependencies

  def pcap_root() builddir/'pcap-root' end
  def coredumper_root() builddir/'coredumper-root' end
  def unwind_root() builddir/'unwind-root' end

  def build_pcap
    chdir builddir/'libpcap-1.2.1' do
      configure :prefix => pcap_root, :disable_shared => true, :enable_static => true
      make
      make :install
    end
    chdir pcap_root do
      ln_s 'include', 'Include' unless File.exists?('Include')
      ln_s 'lib', 'Lib'         unless File.exists?('Lib')
      rm   Dir['lib/libpcap.s*']
    end
  end

  def build_coredumper
    chdir builddir/'coredumper-1.2.1' do
      configure :prefix => coredumper_root, :disable_shared => true, :enable_static => true
      make
      make :install
    end
  end

  def build_libunwind
    chdir builddir/'libunwind-1.0.1' do
      configure :prefix => unwind_root, :disable_shared => true, :enable_static => true
      make
      make :install
    end
  end
end
