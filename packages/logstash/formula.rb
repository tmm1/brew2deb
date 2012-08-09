class Logstash < DebianFormula
  homepage 'http://logstash.net/'
  url 'https://github.com/downloads/derekgr/logstash/logstash-1.1.2.dev-cassandra-monolithic.jar', :using => :nounzip
  md5 'f9344702f44fd78eae52b0b12750989e'

  name 'logstash'
  version '1.1.2+github1'
  section 'utilities'
  description 'a tool for managing events and logs'

  depends \
    'sun-java6-jre'

  def build
    # noop
  end

  def install
    logstash_home = share/'logstash'
    logstash_home.install Pathname.new(@url).basename

    bin.install Dir[workdir+'logstash']

    (var/'log/logstash').mkpath

    (etc/'logstash').mkpath
    (etc/'logstash').install Dir[workdir/'logstash.conf']
    (etc/'init.d').install_p(workdir/'init.d', 'logstash')
  end
end
