class Logstash < DebianFormula
  homepage 'http://logstash.net/'
  url 'https://logstash.objects.dreamhost.com/release/logstash-1.1.5-monolithic.jar', :using => :nounzip
  md5 '8f9d5b94a771a451a7f361e6a306589e'

  name 'logstash'
  version '1.1.5+github1'
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
