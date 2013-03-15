class Pacemaker < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/main/p/pacemaker/pacemaker_1.1.7-1ubuntu2.dsc'
  md5 'a37eb07651fa7c7fc20cdd97b98df63c'
  version '1.1.7-2github3'
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
    [
      #http://bugs.clusterlabs.org/show_bug.cgi?id=5058
      '54266cb5095c68a3afac0be9be93718435352d47.patch',
      #http://bugs.clusterlabs.org/show_bug.cgi?id=5063
      'b3c15a8dae467ed8f76797e5f6b59944b0567bb5.patch',
      '3ab86ab9e8e63c920f7cf493f54eef7e8dfee32a.patch',
      #http://bugs.clusterlabs.org/show_bug.cgi?id=5072
      'fc03be02bf3a045babfe8233cbc99227da71d024.patch',
      'd447452870f97a5032a6ec59f9722cc8e14ba402.patch',
    ]
  end
end
