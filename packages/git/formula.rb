class Git < DebianFormula
  url 'http://kernel.org/pub/software/scm/git/git-1.7.5.4.tar.bz2'
  md5 '4985b774db84d3bbcc2b8d90952552a3'
  homepage 'http://git-scm.com'

  section 'vcs'
  name 'git'
  version '1:1.7.5.4-1+github4'
  description <<-DESC
    The Git DVCS with custom patches and bugfixes for GitHub.
  DESC

  build_depends \
    'libz-dev',
    'libcurl4-gnutls-dev | libcurl3-gnutls-dev',
    'libexpat1-dev',
    'subversion', 'libsvn-perl | libsvn-core-perl',
    'unzip',
    'gettext'

  depends \
    'perl-modules, liberror-perl',
    'libsvn-perl | libsvn-core-perl, libwww-perl, libterm-readkey-perl'

  provides  'git-core', 'git-svn'
  replaces  'git-core', 'git-svn'
  conflicts 'git-core', 'git-svn'

  def patches
    [
      'patches/post-upload-pack-hook.patch',
      'patches/remove-duplicate-dot-have-lines.patch',
      'patches/git-fetch-performance.patch',
      'patches/receive-pack-fsck-object-warnings-non-fatal.patch',
      'patches/archive-gz-external.patch',
      'patches/receive-pack-hide-refs.patch',
      # 'patches/patch-id-eof-fix.patch',     # in 1.7.4.2
      # 'patches/upload-pack-deadlock.patch', # in 1.7.5.1
    ]
  end

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
