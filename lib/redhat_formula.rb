require 'common_formula'

class RedHatFormula < Formula
  attr_rw :name, :description
  attr_rw :maintainer, :section, :arch
  attr_rw :pre_install, :post_install, :pre_uninstall, :post_uninstall

  attr_rw_list :depends, :build_depends
  attr_rw_list :provides, :conflicts, :replaces
  attr_rw_list :config_files

  attr_accessor :skip_build
  attr_writer :installing

  build_depends \
    'gcc',
    'gcc-c++',
    'kernel-devel',
    'patch',
    'curl'

  def self.requires_user(name, opts={})
    @create_user ||= {}
    @create_user.update(opts)
    @create_user[:name] = name
  end

  class << self
    attr_reader :create_user
    @extra_sources = []
  end

  def self.extra_sources
    @extra_sources ||= (self == RedHatFormula ? [] : superclass.extra_sources.dup)
  end

  def self.source(url, opts={})
    extra_sources << [url, opts]
  end

  def download_extra_sources
    self.class.extra_sources.each do |url, opts|
      spec = SoftwareSpecification.new(url, opts)
      downloader = spec.download_strategy.new(url, nil, spec.detect_version, opts)
      downloader.fetch
      chdir(builddir) do
        downloader.stage
      end
    end
  end

  def stage
    if skip_build
      chdir(builddir) do
        @downloader.send :chdir
        yield
      end
    else
      super do
        download_extra_sources
        yield
      end
    end
  end

  def patch
    skip_build ? nil : super
  end

  def postinst
    set_instance_variable 'create_user'

    if @create_user and user = @create_user[:name]
      home = @create_user[:home] || '/nonexistent'

      script = "
        #!/bin/sh
        set -e

        (id #{user} >/dev/null 2>&1) ||
          adduser --system --group --no-create-home --home #{home} #{user}
      "

      paths = Array(@create_user[:chown])
      script += "
        chown -R #{user}:#{user} #{paths.map(&:dump).join(' ')}
      " if paths and paths.any?

      script.ui
    end
  end

  def postrm
    if @create_user and user = @create_user[:name] and @create_user[:remove] != false
      "
        #!/bin/sh
        set -e

        deluser --system #{user}
      ".ui
    end
  end

  def self.package!
    raise 'Missing name/version' if self == RedHatFormula and (!name or !version)

    f = new

    unless RUBY_PLATFORM =~ /darwin/
      # Check for build deps.
      system "/bin/rpm -q #{f.class.build_depends.join(' ')} > /dev/null"
      if $? != 0
        f.send :onoe, 'Missing build dependencies.'
        exit(1)
      end
    end

    built_file = HOMEBREW_WORKDIR + "tmp-build/.built-#{f.name}-#{f.version.gsub(/[^\w]/,'_')}"
    if File.exists?(built_file)
      f.skip_build = true
      f.send :ohai, 'Skipping build (`brew2deb clean` to rebuild)'
    end

    env = ENV.to_hash

    f.brew do
      unless f.skip_build
        f.send :ohai, 'Compiling source'
        f.installing = false
        f.build
      end

      FileUtils.touch(built_file)

      begin
        f.send :ohai, 'Installing binaries'
        f.installing = true
        dir = f.send(:destdir)
        FileUtils.rm_rf(dir)
        FileUtils.mkdir_p(dir)
        f.install
        f.post_install if f.respond_to?(:post_install)
      ensure
        f.installing = false
      end

      ENV.replace(env)

      f.send :ohai, 'Packaging into a .rpm'
      f.package
    end
  end

  def package
    FileUtils.mkdir_p(HOMEBREW_WORKDIR+'pkg')
    Dir.chdir HOMEBREW_WORKDIR+'pkg' do
      epoch, ver = self.class.version.split(':', 2)
      if ver.nil?
        ver, epoch = epoch, nil
      end

      opts = [
        '-n', name,
        '-v', ver,
        '-t', 'rpm',
        '-s', 'dir',
        '--url', self.class.homepage || self.class.url,
        '-C', destdir,
        '--maintainer', maintainer,
        '--category', self.class.section,
      ]

      opts += [
        '--epoch', epoch
      ] if epoch

      opts += [
        '--description', self.class.description.ui.strip
      ] if self.class.description

      opts += [
        '--architecture', self.class.arch.to_s
      ] if self.class.arch

      if self.postinst
        postinst_file = Tempfile.open('postinst')
        postinst_file.puts(postinst)
        chmod 0755, postinst_file.path
        postinst_file.close
        opts += ['--post-install', postinst_file.path]
      end
      if self.postrm
        postrm_file = Tempfile.open('postrm')
        postrm_file.puts(postrm)
        chmod 0755, postrm_file.path
        postrm_file.close
        opts += ['--post-uninstall', postrm_file.path]
      end

      %w[ depends provides replaces conflicts config_files ].each do |type|
        if self.class.send(type).any?
          self.class.send(type).each do |dep|
            opts += ["--#{type.gsub('_','-')}", dep]
          end
        end
      end

      opts << '.'

      safe_system File.expand_path('../../fpm/bin/fpm', __FILE__), *opts
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

  def builddir
    HOMEBREW_WORKDIR+'tmp-build'
  end

  def mkbuilddir
    FileUtils.mkdir_p(builddir)
    raise "Couldn't create build sandbox" if not builddir.directory?

    chdir(builddir) do
      yield
    end
  end
  alias :mktemp :mkbuilddir

  def chdir(dir)
    wd = Dir.pwd
    Dir.chdir(dir)
    yield
  ensure
    Dir.chdir(wd)
  end

  def maintainer
    @maintainer ||= self.class.maintainer || begin
      username = `git config --get user.name`.strip
      useremail = `git config --get user.email`.strip
      raise 'Set maintainer name/email via `git config --global user.name <name>`' if username.empty?
      "#{username} <#{useremail}>"
    end
  end

  def workdir
    HOMEBREW_WORKDIR
  end

  def prefix
    current_pathname_for('usr')
  end

  def etc
    current_pathname_for('etc')
  end

  def var
    current_pathname_for('var')
  end

  def current_pathname_for(dir)
    @installing ? destdir + dir : Pathname.new("/#{dir}")
  end

  def destdir
    HOMEBREW_WORKDIR+'tmp-install'
  end

  def configure(*args)
    if args.last.is_a?(Hash)
      opts = args.pop
      args += opts.map{ |k,v|
        option = k.to_s.gsub('_','-')
        if v == true
          "--#{option}"
        else
          "--#{option}=#{v}"
        end
      }
    end

    sh "./configure", *args
  end

  public

  def build
    configure :prefix => prefix
    make
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end

#class RedHatSourceFormula < RedHatFormula
#  build_depends \
#    'fakeroot',
#    'devscripts',
#    'dpkg-dev'
#
#  def build
#    ENV['DEBEMAIL'] = maintainer
#    if ver = self.class.version
#      safe_system 'dch', '-v', ver, 'brew2deb package'
#    end
#    safe_system 'dpkg-buildpackage', '-rfakeroot', '-us', '-uc'
#  end
#
#  def install
#  end
#
#  def package
#    FileUtils.mkdir_p(HOMEBREW_WORKDIR+'pkg')
#    Dir[HOMEBREW_WORKDIR+'tmp-build'+'*.{dsc,gz,changes,deb,udeb}'].each do |file|
#      FileUtils.cp file, HOMEBREW_WORKDIR+'pkg'
#    end
#  end
#end
