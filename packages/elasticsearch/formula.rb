class ElasticSearch < DebianFormula
  url 'https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.17.8.tar.gz'
  homepage 'http://www.elasticsearch.org'
  md5 'fb02e4e15f27a395903b4a75bbd7e927'

  source 'https://github.com/mobz/elasticsearch-head.git'

  name 'elasticsearch'
  version '0.17.8'
  section 'database'
  description 'You know, for Search'

  build_depends \
    'sun-java6-jdk'

  depends \
    'sun-java6-jre'

  def build
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
    (share/'elasticsearch').install Dir['{bin/elasticsearch.in.sh,lib,*.*}']
    (share/'elasticsearch/web').install Dir[builddir/'elasticsearch-head.git/*']
    ln_s '../../../etc/elasticsearch', share/'elasticsearch/config'
    (etc/'elasticsearch').install Dir['config/*']

    %w( run log/elasticsearch lib/elasticsearch ).each { |path| (var+path).mkpath }
  end
end
