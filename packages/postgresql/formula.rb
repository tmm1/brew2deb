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
    ]
  end
  skip_clean :all

  def install
    make :install, 'DESTDIR' => destdir

    args = ["--disable-debug",
      "--prefix=#{prefix}",
      "--enable-thread-safety",
      "--with-gssapi",
      "--with-krb5",
      "--with-openssl",
      "--with-libxml", "--with-libxslt"]

    args << "--with-python" unless ARGV.include? '--no-python'
    args << "--with-perl" unless ARGV.include? '--no-perl'

    args << "--datadir=#{share}/#{name}"
    args << "--docdir=#{doc}"

    system "./configure", *args
    system "make install-world"
  end
end
