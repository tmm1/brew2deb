$:.unshift File.expand_path('../../homebrew/Library/Homebrew', __FILE__)
require 'tempfile'
require 'global'
require 'formula'
require 'hardware'
require 'etc'

class String
  # Useful for writing indented String and unindent on demand, based on the
  # first line with indentation.
  def unindent
    find_indent = proc{ |l| l.find{|l| !l.strip.empty?}.to_s[/^(\s+)/, 1] }

    lines = self.split("\n")
    space = find_indent[lines]
    space = find_indent[lines.reverse] unless space

    strip.gsub(/^#{space}/, '')
  end
  alias ui unindent

  # Destructive variant of undindent, replacing the String
  def unindent!
    self.replace unindent
  end
  alias ui! unindent!
end

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
        def self.#{attr}!(*list)
          @#{attr} = []
          #{attr}(*list)
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
  attr_rw_list :config_files

  attr_accessor :skip_build
  attr_writer :installing

  build_depends \
    'build-essential',
    'fakeroot',
    'debhelper',
    'libc6-dev',
    'patch',
    'curl'

  class << self
    %w(squeeze lenny).each do |codename|
      define_method(:"#{codename}?") do
        `lsb_release -c | cut -f 2` == codename
      end
    end
  end

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
    @extra_sources ||= (self == DebianFormula ? [] : superclass.extra_sources.dup)
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
    raise 'Missing name/version' if self == DebianFormula and (!name or !version)

    f = new

    unless RUBY_PLATFORM =~ /darwin/
      unless File.exists?('/usr/bin/dpkg-checkbuilddeps') and File.exists?('/usr/lib/pbuilder/pbuilder-satisfydepends')
        f.send :onoe, "Development tools not found (apt-get install dpkg-dev pbuilder)"
        exit(1)
      end

      # Check for build deps.
      f.send :ohai, 'Checking for dependenies.'
      build_deps = f.class.build_depends.join(', ')

      system '/usr/bin/dpkg-checkbuilddeps', '-d', build_deps, '/dev/null'
      if $? != 0
        File.open('/tmp/brew2deb-deps.control','w') do |control|
          control.puts <<CONTROL
Source: mypackage
Maintainer: me@me.com
Build-Depends: #{build_deps}

Package: mypackage
Architecture: any
Description: ohai
CONTROL
        end

        f.send :onoe, "Missing build dependencies. Run one of the following:"
        deps = `/usr/bin/dpkg-checkbuilddeps -d #{build_deps.dump} /dev/null 2>&1`.strip
        to_install = deps.split(':',3).last.gsub(/\([^)]*\)/,'').gsub(/\|\s[^\s]*/,'')
        f.send :onoe, "  sudo apt-get install #{to_install.split.join(' ')}"
        f.send :onoe, "  sudo /usr/lib/pbuilder/pbuilder-satisfydepends --control /tmp/brew2deb-deps.control"
        exit(1)

        # system 'sudo', '/usr/lib/pbuilder/pbuilder-satisfydepends', '--control', '/tmp/brew2deb-deps.control'
        # exit(1) if $? != 0
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

      f.send :ohai, 'Packaging into a .deb'
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
        '-t', 'deb',
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

      # Calculate shared library dependencies.
      begin
        tmpdir = Dir.mktmpdir('brew2deb-shlibs')
        Dir.chdir tmpdir do
          FileUtils.mkdir_p 'debian'

          File.open('debian/compat','w') { |f| f.puts '8' }
          File.open('debian/control','w'){ |f| f.puts "Source: #{name}\nPackage: #{name}" }
          out = `dpkg-gensymbols -P#{destdir} -p#{name} -v#{self.class.version} 2>&1 && fakeroot dh_shlibdeps -P#{destdir} -p#{name} 2>&1`
          if $?.exitstatus != 0
            opoo "Auto-calculation of shared library dependencies failed\n    #{out.split("\n").join("\n    ")}"
          elsif File.exists?("debian/#{name}.substvars") && (substvars = File.read("debian/#{name}.substvars"))
            substvars.strip.gsub('shlibs:Depends=', '').split(', ').each do |dep|
              next if dep =~ /^#{name} /
              opts += ["--depends", dep]
            end
          end
        end
      ensure
        FileUtils.rm_rf tmpdir
        FileUtils.rm_rf destdir/'DEBIAN'
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

      if username.empty?
        username = Etc.getlogin
        useremail = "#{username}@#{`hostname`.strip}"
      end

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

class DebianSourceFormula < DebianFormula
  build_depends \
    'devscripts',
    'dpkg-dev'

  def stage
    FileUtils.rm_rf builddir if File.exists?(builddir)
    super
  end

  def build
    ENV['DEBEMAIL'] = maintainer
    if ver = self.class.version
      safe_system 'dch', '-v', ver, 'brew2deb package'
    end
    safe_system 'dpkg-buildpackage', '-rfakeroot', '-us', '-uc'
  rescue RuntimeError => e
    if e.message =~ /while executing/
      onoe 'Build failed. Try: sudo /usr/lib/pbuilder/pbuilder-satisfydepends --control tmp-build/*/debian/control'
    else
      raise e
    end
  end

  def install
  end

  def package
    FileUtils.mkdir_p(HOMEBREW_WORKDIR+'pkg')
    Dir[HOMEBREW_WORKDIR+'tmp-build'+'*.{dsc,gz,changes,deb,udeb}'].each do |file|
      FileUtils.cp file, HOMEBREW_WORKDIR+'pkg'
    end
  end
end
