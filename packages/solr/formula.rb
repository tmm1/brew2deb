class Solr < DebianFormula
  homepage 'http://lucene.apache.org/solr/'
  url 'http://archive.apache.org/dist/lucene/solr/3.3.0/apache-solr-3.3.0.tgz'
  md5 '048e2aa7e16358600fa5fe3570b90018'

  name 'solr'
  version '3.3.0+github1'
  section 'database'
  description 'Enterprise search platform'

  build_depends \
    'oracle-java7-jdk | default-jdk'

  depends \
    'oracle-java7-jre | default-jre'

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
