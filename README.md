# brew2deb

This is a hack that combines [Homebrew](http://github.com/mxcl/homebrew)
and [FPM](http://github.com/jordansissel/fpm) to build a Ruby version of
[pacman](http://www.archlinux.org/pacman/)'s
[makepkg](http://www.archlinux.org/pacman/makepkg.8.html).

## setup

```
$ apt-get install dpkg-dev pbuilder
$ apt-get install ruby rubygems libjson-ruby
$ apt-get install git
$ apt-get install curl
$ git clone git://github.com/tmm1/brew2deb
```

## usage

```
$ cd packages/git
$ tree
├── formula.rb
└── patches
    ├── git-fetch-performance.diff
    ├── patch-id-eof-fix.diff
    ├── post-upload-pack-hook.diff
    ├── remove-duplicate-dot-have-lines.diff
    └── upload-pack-deadlock.diff
```

```
$ ../../bin/brew2deb
==> Downloading http://kernel.org/pub/software/scm/git/git-1.7.5.4.tar.bz2
==> Extracting source
==> Downloading patches
==> Patching
patching file upload-pack.c
patching file Makefile
Hunk #1 succeeded at 539 (offset -8 lines).
Hunk #2 succeeded at 642 (offset -8 lines).
patching file bisect.c
patching file builtin/fetch-pack.c
patching file builtin/receive-pack.c
patching file sha1-array.c
patching file sha1-array.h
patching file transport.c
patching file transport.h
patching file builtin/fetch-pack.c
==> Compiling source
GIT_VERSION = 1.7.5.4
    * new build flags or prefix
    CC daemon.o
    CC abspath.o
    ...
    GEN bin-wrappers/test-svn-fe
    GEN bin-wrappers/test-treap
    GEN bin-wrappers/test-index-version
    GEN bin-wrappers/test-mktemp
==> Installing binaries
    SUBDIR gitweb
    SUBDIR ../
make[2]: `GIT-VERSION-FILE' is up to date.
    GEN git-instaweb
    SUBDIR perl
    SUBDIR git_remote_helpers
    SUBDIR templates
install -d -m 755 '/home/tmm1/brew2deb/packages/git/install/usr/bin'
install -d -m 755 '/home/tmm1/brew2deb/packages/git/install/usr/lib/git-core'
    ...
==> Packaging into a .deb
Created /home/tmm1/brew2deb/packages/git/pkg/git_1.7.5.4-1+github1_amd64.deb
```

```
$ dpkg --info pkg/git_1.7.5.4-1+github1_amd64.deb
 Package: git
 Version: 1:1.7.5.4-1+github1
 Architecture: amd64
 Maintainer: Aman Gupta <aman@tmm1.net>
 Depends: perl-modules, liberror-perl, libsvn-perl | libsvn-core-perl, libwww-perl, libterm-readkey-perl
 Provides: git-core, git-svn
 Replaces: git-core, git-svn
 Conflicts: git-core, git-svn
 Standards-Version: 3.9.1
 Section: vcs
 Priority: extra
 Homepage: http://git-scm.com
 Description: The Git DVCS with custom patches and bugfixes for GitHub.
```
