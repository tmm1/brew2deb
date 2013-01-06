class Kestrel < DebianFormula
  url 'http://robey.github.com/kestrel/download/kestrel-2.4.1.zip'
  md5 '623e325823a97dd6e5d58f7a3d114c9f'

  name 'kestrel'
  version '2.4.1+github3'
  description 'a simple, distributed message queue written on the JVM'
  section 'utils'
  arch 'all'

  build_depends \
    'sun-java6-jdk', \
    'sbt'

  depends \
    'sun-java6-jre', \
    'daemon', \
    'scala'


  def build
    mv 'scripts/kestrel.sh', 'scripts/kestrel'
    sh 'chmod +x scripts/kestrel'
    inreplace 'scripts/kestrel' do |s|
      s.gsub! '/usr/local/bin', '/usr/bin'
      s.gsub! '/usr/local', '/usr/share'
      s.gsub! '.sh', ''
      s.gsub! '/opt/jdk', '/usr'
    end
  end

  def install
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/kestrel_2.9.2-2.4.1.jar')
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/libs')
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/config')
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/scripts')
    (etc/'init.d').install_p(builddir/'kestrel-2.4.1/scripts/kestrel')
    (var+'run/kestrel').mkpath
    (var+'log/kestrel').mkpath
    (var+'spool/kestrel').mkpath
  end
end
