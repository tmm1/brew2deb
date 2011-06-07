$:.unshift File.expand_path('../../../homebrew/Library/Homebrew', __FILE__)
require 'global'
require 'formula'

class Formula
  def self.attr_rw_list(*attrs)
    attrs.each do |attr|
      instance_variable_set("@#{attr}", [])
      class_eval %Q{
        def self.#{attr}(*list)
          @#{attr} ||= superclass.respond_to?(:#{attr}) ? superclass.#{attr} : []
          list.empty? ? @#{attr} : @#{attr} += list
          @#{attr}.uniq!
          @#{attr}
        end
      }
    end
  end
end

class DebianFormula < Formula
  attr_rw :name, :description
  attr_rw :maintainer, :section, :arch
  attr_rw :pre_install, :post_install, :pre_uninstall, :post_uninstall

  attr_rw_list :depends, :build_depends
  attr_rw_list :provides, :conflicts, :replaces

  build_depends \
    'build-essential',
    'libc6-dev',
    'curl'

  def self.package!
    f = new

    # Check for build deps.
    system '/usr/bin/dpkg-checkbuilddeps', '-d', f.class.build_depends.join(', '), '/dev/null'
    if $? != 0
      f.send :onoe, 'Missing build dependencies.'
      exit(1)
    end

    f.brew do
      f.send :ohai, 'Compiling source'
      f.build

      f.send :ohai, 'Installing binaries'
      f.install

      f.send :ohai, 'Packaging into a .deb'
      f.package
    end
  end

  def package
    Dir.chdir HOMEBREW_WORKDIR do
      # TODO: use FPM::Builder directly here
      opts = [
        # maintainer
        # section (category)
        # architecture
        # fix description spacing
        # conflicts/replaces
        '-n', name,
        '-v', version,
        '-t', 'deb',
        '-s', 'dir',
        '--url', self.class.homepage || self.class.url,
        '-C', destdir,
        '--description', self.class.description
      ]

      %w[ depends provides replaces ].each do |type|
        if self.class.send(type).any?
          self.class.send(type).each do |dep|
            opts += ["--#{type}", dep]
          end
        end
      end

      opts << '.'

      safe_system File.expand_path('../../../fpm/bin/fpm', __FILE__), *opts
    end
  end

  protected

  alias :sh :system

  def make(*args)
    env = args.pop if args.last.is_a?(Hash)
    env ||= {}

    args += env.map{ |k,v| "#{k}=#{v}" }
    args.map!{ |a| a.to_s }

    safe_system 'make', *args
  end

  def skip_clean_all?
    true
  end

  def mksrcdir
    srcdir = HOMEBREW_WORKDIR+'src'
    FileUtils.mkdir_p(srcdir)
    raise "Couldn't create build sandbox" if not srcdir.directory?

    begin
      wd=Dir.pwd
      Dir.chdir srcdir
      yield
    ensure
      Dir.chdir wd
    end
  end
  alias :mktemp :mksrcdir

  def prefix
    '/usr'
  end

  def destdir
    HOMEBREW_WORKDIR+'pkg'
  end
end

class Git < DebianFormula
  url 'http://kernel.org/pub/software/scm/git/git-1.7.4.2.tar.bz2'
  md5 '4b2df3f916061439ae105d7a27637925'
  homepage 'http://git-scm.com'

  section 'vcs'
  name 'git'
  version '1.7.4.2~github1'
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

  def patches
    [
      'patches/1000-receive-pack-avoid-dup-alternate-ref-output.diff',
      'patches/1001-upload-pack-deadlock.diff',
      'patches/1002-git-fetch-performance.diff'
      # 'patches/1003-patch-id-eof-fix.diff' # in 1.7.4.2 already
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
      'prefix' => prefix,
      'gitexecdir' => '/usr/lib/git-core',
      'NO_CROSS_DIRECTORY_HARDLINKS' => 1,
      # 'NO_PERL' => 1,
      # 'NO_PYTHON' => 1,
      'NO_TCLTK' => 1
    }
  end
end

if __FILE__ == $0
  Object.__send__ :remove_const, :HOMEBREW_CACHE
  HOMEBREW_WORKDIR = Pathname.new(File.expand_path('../', __FILE__))
  HOMEBREW_CACHE = HOMEBREW_WORKDIR+'src'
  FileUtils.mkdir_p(HOMEBREW_CACHE)

  Git.package!
end
