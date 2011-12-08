class Postgresql < DebianFormula
  url 'http://ftp.postgresql.org/pub/source/v9.1.1/postgresql-9.1.1.tar.bz2'
  md5 '061a9f17323117c9358ed60f33ecff78'
  homepage 'http://www.postgresql.org/'

  section 'interpreters'
  name 'postgresql9'
  version '9.1.1+github1'
  description 'Elephant DB'

  build_depends \
    'libreadline5-dev'

  depends \
    'libreadline5',
    'openssl'

  def options
    [
      ['--no-python', 'Build without Python support.'],
      ['--no-perl', 'Build without Perl support.'],
      ['--enable-dtrace', 'Build with DTrace support.']
    ]
  end
  skip_clean :all

  def install
    make :install, 'DESTDIR' => destdir

    ENV.libxml2 if MacOS.snow_leopard?

    args = ["--disable-debug",
      "--prefix=#{prefix}",
    "--enable-thread-safety",
      "--with-bonjour",
      "--with-gssapi",
      "--with-krb5",
      "--with-openssl",
      "--with-libxml", "--with-libxslt"]

    args << "--with-python" unless ARGV.include? '--no-python'
    args << "--with-perl" unless ARGV.include? '--no-perl'
    args << "--enable-dtrace" if ARGV.include? '--enable-dtrace'

    args << "--with-ossp-uuid"

    args << "--datadir=#{share}/#{name}"
    args << "--docdir=#{doc}"

    ENV.append 'CFLAGS', `uuid-config --cflags`.strip
    ENV.append 'LDFLAGS', `uuid-config --ldflags`.strip
    ENV.append 'LIBS', `uuid-config --libs`.strip

    system "./configure", *args
    system "make install-world"
  end
end
