class Vitess < DebianFormula
  name 'vitess'
  url 'https://vitess.googlecode.com/hg/', :revision => '02959b6b17b8'
  description 'mysql multiplexer-proxy'

  depends 'python-mysqldb', 'libmysqlclient16'
  build_depends 'python-mysqldb', 'libmysqlclient-dev', 'go'
  version '20120612-weekly'

  def build
    system "mkdir -p src/code.google.com/p/vitess"
    system "mv `find .  -maxdepth 1 ! -name src -a ! -name '.' -a ! -name '..'` src/code.google.com/p/vitess"
    ENV['GO_PATH'] = File.join Dir.pwd
    ENV['PATH'] = "#{ENV['PATH']}:/usr/local/go/bin"
    ENV['MYSQL_CONFIG'] = '/usr/bin/mysql_config'
    system "bash -c 'cd $GO_PATH/src/code.google.com/p/vitess && ./bootstrap.sh && source ./dev.env && cd go && make'"
  end

  def install
    system "mkdir -p #{destdir}/bin"
    system "cp src/code.google.com/p/vitess/go/cmd/vtocc/vtocc #{destdir}/bin/"    
    system "cp src/code.google.com/p/vitess/go/cmd/normalizer/normalizer #{destdir}/bin/"    
    system "cp -r dist/*/lib #{destdir}/"    
  end
end
