class Logstash < DebianFormula
  homepage 'http://logstash.net/'
  url 'http://semicomplete.com/files/logstash/logstash-1.1.1-monolithic.jar', :using => :nounzip
  md5 'cecabd2dda920e1ce4325cd7b22c2cca'

  name 'logstash'
  version '1.1.2+github2'
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
