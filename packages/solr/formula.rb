class Solr < DebianFormula
  homepage 'http://lucene.apache.org/solr/'
  url 'http://www.eng.lsu.edu/mirrors/apache/lucene/solr/3.2.0/apache-solr-3.2.0.tgz'
  md5 '0849a7242f6f861e3a8d5592bd9580c5'

  name 'solr'
  version '3.2.0+github1'
  section 'database'
  description 'Enterprise search platform'

  build_depends \
    'sun-java6-jdk'

  depends \
    'sun-java6-jre'

  def build
    warfile = File.expand_path('example/webapps/solr.war')

    FileUtils.mkdir_p 'war'
    Dir.chdir 'war' do
      sh 'jar', 'xvf', warfile
    end
  end

  def install
    solr_home = share+'solr'
    (solr_home+'lib').install Dir['dist/*.{war,jar}']

    Dir.chdir 'example' do
      (solr_home+'jetty').install Dir['{start.jar,etc,lib,webapps}']
    end

    lucene_home = share+'lucene'
    (lucene_home+'lib').install Dir['war/WEB-INF/lib/lucene-*.jar']

    bin.install Dir[workdir+'solr*']

    (var+'log/solr').mkpath
  end
end
