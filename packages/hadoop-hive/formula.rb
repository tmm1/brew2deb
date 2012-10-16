class Hive < DebianFormula
  homepage 'https://github.com/riptano/hive'
  url 'https://github.com/riptano/hive.git', :sha => '7c0308078d'

  name 'hadoop-hive'
  section 'devel'
  version '0.8.1+github1'
  description 'A query tool over Hadoop and Cassandra storage'

  build_depends \
    'ant',
    'sun-java6-jdk'

  depends \
    'sun-java6-jre | sun-java6-jdk',
    'hadoop'

  def build
    sh 'ant', 'package'
  end

  def install
    ['lib', 'bin', 'scripts'].each do |dir|
      (lib/'hive').install_p('build/dist/' + dir)
    end

    (etc/'hive').install_p('build/dist/conf')
    (lib/'hive/conf').make_relative_symlink(etc/'hive/conf')

    bin.install(workdir/'hive')
    (lib/'hive/bin').install_p(workdir/'hiverc', 'hiverc')
  end
end
