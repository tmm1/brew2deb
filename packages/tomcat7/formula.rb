# Sorry, tomcat7 is Ubuntu only :(

class Tomcat7 < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/main/t/tomcat7/tomcat7_7.0.34-0ubuntu1.dsc'
  md5 'e0fd89009ac395f73af6761bf160422e'
  version '7.0.34-0ubuntu1'

  build_depends \
    'default-jdk',
    'ant-optional',
    'maven-repo-helper (>> 1.0.1)',
    'libecj-java',
    'javahelper',
    'junit4',
    'libjstl1.1-java',
    'libjakarta-taglibs-standard-java'

  def build
    ENV['DEB_BUILD_OPTIONS'] = 'nocheck' # skip the junit crap
    ENV['PATH'] = "#{ENV['PATH']}:/usr/lib/jvm/default-java/bin"

    super
  end
end
