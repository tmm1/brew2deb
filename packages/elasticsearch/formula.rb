class ElasticSearch < DebianFormula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.9.tar.gz'
  homepage 'http://www.elasticsearch.org'
  md5 'fbf1ca717239ee477f4742b47393b63f'

  source 'http://api.cld.me/3d3d100w3I1B2s0L040o/download/lucene-highlighter-3.6-SNAPSHOT.jar'

  name 'elasticsearch'
  version '0.19.9+github2'
  section 'database'
  description 'You know, for Search'

  build_depends 'openjdk-6-jdk'
  depends 'openjdk-6-jre'

  config_files \
    '/etc/elasticsearch/elasticsearch.yml'

  def build
    sh 'bin/plugin -install mobz/elasticsearch-head'
    sh 'bin/plugin -install lukas-vlcek/bigdesk'
    sh 'bin/plugin -install river-twitter'

    rm_f Dir["bin/*.bat"]
    mv 'bin/plugin', 'bin/elasticsearch-plugin'

    inreplace %w[ bin/elasticsearch bin/elasticsearch-plugin ] do |s|
      s.gsub! %{ES_HOME=`dirname "$SCRIPT"`/..}, 'ES_HOME=/usr/share/elasticsearch/'
    end

    inreplace 'bin/elasticsearch.in.sh' do |s|
      s << "\n"
      s << "# System-wide settings\n"
      s << "pidfile=/var/run/elasticsearch.pid\n"
      #s << "ES_JAVA_OPTS=-Des.config=/etc/elasticsearch/elasticsearch.yml\n"
    end

    inreplace "config/elasticsearch.yml" do |s|
      s.gsub! "#cluster:\n#  name: elasticsearch", <<-EOS.undent
        cluster:
          name: escluster

        path:
          logs: /var/log/elasticsearch
          data: /var/lib/elasticsearch
      EOS
    end
  end

  def install
    (prefix/'bin').install Dir['bin/elasticsearch{,-plugin}']
    (share/'elasticsearch').install Dir['{bin/elasticsearch.in.sh,lib,plugins,*.*}']
    ln_s '../../../etc/elasticsearch', share/'elasticsearch/config'
    (etc/'elasticsearch').install Dir['config/*']

    (share/'share/elasticsearch/lib/lucene-highlighter-3.5.0.jar').install builddir/'lucene-highlighter-3.6-SNAPSHOT.jar'

    %w( run log/elasticsearch lib/elasticsearch ).each { |path| (var+path).mkpath }
  end
end
