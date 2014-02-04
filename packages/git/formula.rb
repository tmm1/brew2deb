class Git < DebianFormula
  url 'git@github.com:github/git.git', :tag => 'github-1.8.1.5-3'
  homepage 'http://git-scm.com'

  section 'vcs'
  name 'git'
  version '2:1.8.1.5-1+github3'
  description <<-DESC
    The Git DVCS with custom patches and bugfixes for GitHub.
  DESC

  build_depends \
    'libz-dev',
    'libcurl4-gnutls-dev | libcurl3-gnutls-dev',
    'libexpat1-dev',
    'subversion',
    'libsvn-perl | libsvn-core-perl',
    'unzip',
    'gettext',
    'libssl-dev',
    'libssl0.9.8'

  depends \
    'perl-modules',
    'liberror-perl',
    'libsvn-perl | libsvn-core-perl',
    'libwww-perl',
    'libterm-readkey-perl'

  provides  'git-core', 'git-svn'
  replaces  'git-core', 'git-svn'
  conflicts 'git-core', 'git-svn'

  def build
    make(vars)
  end

  def install
    make(:install, vars.merge('DESTDIR' => destdir))
  end

  private

  def vars
    {
      'prefix' => '/usr',
      'gitexecdir' => '/usr/lib/git-core',
      # 'NO_CROSS_DIRECTORY_HARDLINKS' => 1,
      # 'NO_PERL' => 1,
      # 'NO_PYTHON' => 1,
      'NO_TCLTK' => 1
    }
  end
end
