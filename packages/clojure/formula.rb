class Leiningen < DebianFormula
  homepage 'https://github.com/clojure/clojure'

  url 'https://github.com/downloads/clojure/clojure/clojure-1.2.1.zip'

  arch 'all'
  name 'clojure'
  section 'devel'
  version '1.2.1+github1'
  description 'The Clojure programming language'

  depends \
    'sun-java6-jre | sun-java6-jdk | openjdk-6-jre | openjdk-7-jre',
    'rlwrap'

  def build
    FileUtils.cp('clojure.jar', "clojure-1.2.1+github1.jar")
  end

  def install
    (prefix/'share/java').install "clojure-1.2.1+github1.jar"
  end
end
