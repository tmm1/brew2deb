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
  attr_rw :pre_install, :post_install, :pre_uninstall, :post_uninstall

  attr_rw_list :requires, :depends, :build_depends
  attr_rw_list :provides, :conflicts, :replaces

  build_depends \
    'build-essential',
    'libc6-dev',
    'curl'

  def package
    # TODO: use FPM::Builder directly here
    tmp = Pathname.new Dir.mktmpdir("homebrew-#{name}-#{version}")
    raise "Couldn't create build sandbox" if not tmp.directory?

    begin
      wd=Dir.pwd
      Dir.chdir tmp

      sh 'fpm',
        '-n', name,
        '-v', version,
        '-t', 'deb',
        '-s', 'dir',
        '--url', self.class.homepage || self.class.url,
        '-C', destdir,
        '--description', self.class.description,
        '.'
        # add maintainer
        # fix description
        # add depends list
        # section
        # architecture

      FileUtils.mv Dir['*.deb'], HOMEBREW_CACHE
    ensure
      Dir.chdir wd
      tmp.rmtree
    end
  end

  protected

  alias :sh :system

  def make(*args)
    env = args.pop if args.last.is_a?(Hash)
    env ||= {}

    args += env.map{ |k,v| "#{k}=#{v}" }
    args.map!{ |a| a.to_s }

    sh 'make', *args
  end

  def skip_clean_all?
    true
  end

  def mksrcdir
    FileUtils.mkdir_p('src')
    tmp = Pathname.new File.expand_path('src')
    raise "Couldn't create build sandbox" if not tmp.directory?

    begin
      wd=Dir.pwd
      Dir.chdir tmp
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
    HOMEBREW_CACHE+'pkg'
  end
end

class Git < DebianFormula
  url 'http://kernel.org/pub/software/scm/git/git-1.7.4.2.tar.bz2'
  md5 '4b2df3f916061439ae105d7a27637925'
  homepage 'http://git-scm.com'

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

  def build
    make \
      'NO_CROSS_DIRECTORY_HARDLINKS' => 1,
      'NO_TCLTK' => 1,
      # 'NO_PERL' => 1,
      # 'NO_PYTHON' => 1,
      'prefix' => prefix,
      'gitexecdir' => '/usr/lib/git-core'
  end

  def install
    make :install,
      'DESTDIR' => destdir,
      'NO_CROSS_DIRECTORY_HARDLINKS' => 1,
      'NO_TCLTK' => 1,
      'prefix' => prefix,
      'gitexecdir' => '/usr/lib/git-core'
  end
end

if __FILE__ == $0
  Object.__send__ :remove_const, :HOMEBREW_CACHE
  HOMEBREW_CACHE = Pathname.new(File.expand_path('../', __FILE__))

  # p [:prefix=, HOMEBREW_PREFIX]
  # p [:repo=,   HOMEBREW_REPOSITORY]
  # p [:cache=,  HOMEBREW_CACHE]
  # p [:cellar=, HOMEBREW_CELLAR]

  # p Git.homepage
  # p Git.build_depends


  f = Git.new
  # p [Git.version, f.version]
  # p f
  # p f.path

  # Check for build deps.
  system '/usr/bin/dpkg-checkbuilddeps', '-d', f.class.build_depends.join(', '), '/dev/null'
  if $? != 0
    f.send :onoe, 'Missing build dependencies.'
    exit(1)
  end

  f.brew do
    f.build
    f.install
    f.package
  end
end

__END__

class REE < DebianFormula
  homepage 'http://rubyenterpriseedition.com/'
  url 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.03.tar.gz'
  md5 '038604ce25349e54363c5df9cd535ec8'

  name 'ruby-enterprise'
  description <<-DESC
    Ruby Enterprise Edition.
  DESC

  def build
    sh "./configure --prefix=#{prefix}"
    sh "make"
  end

  def install
    sh "make install DESTDIR=#{destdir}"
  end
end

