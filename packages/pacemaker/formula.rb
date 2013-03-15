class Pacemaker < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/main/p/pacemaker/pacemaker_1.1.7-1ubuntu2.dsc'
  md5 'a37eb07651fa7c7fc20cdd97b98df63c'
  version '1.1.7-2github1'
  replaces 'crmsh, libqb, libqb-dev'
  conflicts 'crmsh, libqb, libqb-dev'

  def build
    inreplace "debian/control" do |s|
      s.gsub!(/libqb-dev$/, 'libqb, libqb-dev')
    end
    # I think this is required because of quilt?
    ENV['EDITOR'] = '/bin/true'
    safe_system 'dpkg-source', '--commit', '.', 'brew2deb'
    super
  end

  def patches
    #http://bugs.clusterlabs.org/show_bug.cgi?id=5072
    'fc03be02bf3a045babfe8233cbc99227da71d024.patch'
  end
end
