class Git < DebianFormula
  url 'https://git-core.googlecode.com/files/git-1.7.10.tar.gz'
  md5 'ab2716db51580037c7ebda4c8e9d56eb'
  homepage 'http://git-scm.com'

  section 'vcs'
  name 'git'
  version '1:1.7.10-1+github1'
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

      # allow turning off .have lines entirely
      'patches/receive-pack-advertise-alternates.patch',

      # fsckObjects doesn't show user warnings
      'patches/receive-pack-fsck-object-warnings-non-fatal.patch',

      # hide refs/pull/* via receive.hiderefs
      'patches/receive-pack-hide-refs.patch',

      # ignore invalid timezones
      'patches/tz-fsck-warning.patch',

      # github/git#1: statistics reporting
      'patches/git-stats.patch',
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
