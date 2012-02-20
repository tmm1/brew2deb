class Sbt < DebianFormula
  url 'http://typesafe.artifactoryonline.com/typesafe/ivy-releases/org.scala-tools.sbt/sbt-launch/0.11.2/sbt-launch.jar', :using => :nounzip
  md5 '2886cc391e38fa233b3e6c0ec9adfa1e'

  name 'sbt'
  version '0.11.2'
  section 'utils'
  description 'a build tool for Scala and Java projects that aims to do the basics well'

  build_depends \
    'sun-java6-jdk'

  depends \
    'sun-java6-jre'

  def build
    #noop
  end

  def install
    (share/'sbt').install builddir/'sbt-launch.jar'
    bin.install Dir[workdir+'sbt']
  end
end
