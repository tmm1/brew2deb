class Git < DebianFormula
  url 'http://pkgs.fedoraproject.org/repo/pkgs/git/git-1.7.5.4.tar.bz2/4985b774db84d3bbcc2b8d90952552a3/git-1.7.5.4.tar.bz2'
  md5 '4985b774db84d3bbcc2b8d90952552a3'
  homepage 'http://git-scm.com'

  section 'vcs'
  name 'git'
  version '1:1.7.5.4-1+github28'
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
    'libssl-dev'

  depends \
    'perl-modules',
    'liberror-perl',
    'libsvn-perl | libsvn-core-perl',
    'libwww-perl',
    'libterm-readkey-perl'

  provides  'git-core', 'git-svn'
  replaces  'git-core', 'git-svn'
  conflicts 'git-core', 'git-svn'

  def patches
    [
      # fix race condition and hide warnings in pack-objects
      'patches/pack-object-race.patch',

      # fire a hook on post-upload so we can track # of clones
      'patches/post-upload-pack-hook.patch',

      # eliminate duplicate .have refs
      'patches/remove-duplicate-dot-have-lines.patch',

      # allow turning off .have lines entirely
      'patches/receive-pack-advertise-alternates.patch',

      # speed up git-fetch with large number of refs
      'patches/git-fetch-performance.patch',

      # fsckObjects doesn't show user warnings
      'patches/receive-pack-fsck-object-warnings-non-fatal.patch',

      # add .tar.gz to git-archive
      'patches/archive-gz-external.patch',

      # hide refs/pull/* via receive.hiderefs
      'patches/receive-pack-hide-refs.patch',

      # ignore invalid timezones
      'patches/tz-fsck-warning.patch',

      # github/git#1: https://github.com/github/git/compare/git-stats.diff
      'patches/git-stats.diff',
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
