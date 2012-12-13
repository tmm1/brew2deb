class LiveBuild < DebianSourceFormula
  url 'git://live.debian.net/git/live-build.git', :tag => 'debian/2.0.12-2'
  version '2.0.12-2+github1'

  def build
    inreplace "debian/control" do |s|
      s.gsub!(/^Build-Depends: debhelper \(>= [\d\.]+~\)/, 'Build-Depends: debhelper (>= 7.0.15~)')
    end

    super
  end
end
