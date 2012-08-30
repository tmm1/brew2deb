class Leiningen < DebianFormula
  homepage 'https://github.com/technomancy/leiningen'

  url 'https://github.com/downloads/technomancy/leiningen/leiningen-1.7.0-standalone.jar'

  arch 'all'
  name 'leiningen'
  section 'devel'
  version '1.7.1+github1'
  description 'A build tool for Clojure projects'

  depends \
    'ant',
    'clojure1.2',
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
    'rlwrap',
    'wget'

  def build
  end

  def install
    # Grab a temp file that will become /bin/lein.
    sh "wget -O lein https://raw.github.com/technomancy/leiningen/stable/bin/lein"
    sh "chmod a+x lein"

    FileUtils.cp 'lein', 'pkg'
  end
end
