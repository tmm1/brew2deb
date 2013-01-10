class Leiningen < DebianFormula
  homepage 'https://github.com/technomancy/leiningen'

  url 'https://github.com/downloads/technomancy/leiningen/leiningen-2.0.0-preview10-standalone.jar'

  arch 'all'
  name 'leiningen'
  section 'devel'
  version '2.0.0-preview10+github2'
  description 'A build tool for Clojure projects'

  depends \
    'ant',
    'clojure',
    'libbackport-util-concurrent-java',
    'libclassworlds-java',
    'libclucy-clojure',
    'libjaxp1.3-java',
    'liblucene2-java',
    'maven2',
    'libplexus-container-default-java',
    'libplexus-utils-java',
    'librobert-hooke-clojure',
    'libwagon-java',
    'sun-java6-jre | sun-java6-jdk | openjdk-6-jre | openjdk-7-jre',
    'rlwrap'

  def build
    FileUtils.cp HOMEBREW_WORKDIR+'lein', 'lein'
    sh "chmod a+x lein"
  end

  def install
    (prefix/'bin').install 'lein'
    (prefix/'share/java').install 'leiningen-2.0.0-preview10-standalone.jar'
  end
end
