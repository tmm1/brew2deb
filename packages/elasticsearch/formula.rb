class ElasticSearch < DebianFormula
  url 'http://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.20.2.tar.gz'
  homepage 'http://www.elasticsearch.org'
  md5 'fe50d6f4b11e9e0d1ccf661b32f15fbc'

  source 'http://api.cld.me/3d3d100w3I1B2s0L040o/download/lucene-highlighter-3.6-SNAPSHOT.jar'

  name 'elasticsearch'
  version '0.20.2+github1'
  section 'database'
  description 'You know, for Search'

  build_depends 'java6-sdk | java7-jdk | java-compiler'
  depends 'java7-runtime-headless | java6-runtime-headless | java7-runtime | java6-runtime'

  config_files \
    '/etc/elasticsearch/elasticsearch.yml'

  def build
    rm_f Dir["bin/*.bat"]
    rm_f Dir["lib/sigar/*-solaris.so"]
    rm_f Dir["lib/sigar/*-freebsd-*.so"]
    rm_f Dir["lib/sigar/*ia64*.so"]

    if Hardware.is_32_bit?
      rm_f "lib/sigar/libsigar-amd64-linux.so"
    else
      rm_f "lib/sigar/libsigar-x86-linux.so"
    end

    mv 'bin/plugin', 'bin/elasticsearch-plugin'

    inreplace %w[ bin/elasticsearch bin/elasticsearch-plugin ] do |s|
      s.gsub! %{ES_HOME=`dirname "$SCRIPT"`/..}, ': ${ES_HOME:=/usr/share/elasticsearch/}'
      s.gsub! %{-cp "$ES_HOME/lib/*"}, '-cp "$ES_HOME/lib/*" -cp "$ES_LIB/lib/*"'
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
