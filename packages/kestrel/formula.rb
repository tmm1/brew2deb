class Kestrel < DebianFormula
  url 'http://robey.github.com/kestrel/download/kestrel-2.1.5.zip'
  md5 '256503b15fb7feec37e100f5ef92f94d'

  name 'kestrel'
  version '2.1.5'
  description 'a simple, distributed message queue written on the JVM'
  section 'utils'
  arch 'all'

  build_depends \
    'sun-java6-jdk', \
    'sbt'

  depends \
    'sun-java6-jre', \
    'daemon'

  def build
    mv 'scripts/kestrel.sh', 'scripts/kestrel'
    inreplace 'scripts/kestrel' do |s|
      s.gsub! '/usr/local/bin', '/usr/bin'
      s.gsub! '/usr/local', '/usr/share'
      s.gsub! '.sh', ''
    end
  end

  def install
    (share/'kestrel/current').install(builddir/'kestrel-2.1.5/kestrel-2.1.5.jar')
    (share/'kestrel/current').install(builddir/'kestrel-2.1.5/libs')
    (etc/'init.d').install(builddir/'kestrel-2.1.5/scripts/kestrel')
    (var+'log/kestrel').mkpath
    (var+'pid/kestrel').mkpath
    (var+'spool/kestrel').mkpath
  end
end
