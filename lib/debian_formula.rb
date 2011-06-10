$:.unshift File.expand_path('../../homebrew/Library/Homebrew', __FILE__)
require 'global'
require 'formula'

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

  attr_writer :installing

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
      f.installing = false
      f.build

      begin
        f.send :ohai, 'Installing binaries'
        f.installing = true
        FileUtils.rm_rf(f.send(:destdir))
        f.install
      ensure
        f.installing = false
      end

      f.send :ohai, 'Packaging into a .deb'
      f.package
    end
  end

  def package
    FileUtils.mkdir_p(HOMEBREW_WORKDIR+'pkg')
    Dir.chdir HOMEBREW_WORKDIR+'pkg' do
      # TODO: use FPM::Builder directly here
      opts = [
        # architecture
        '-n', name,
        '-v', version,
        '-t', 'deb',
        '-s', 'dir',
        '--url', self.class.homepage || self.class.url,
        '-C', destdir,
        '--maintainer', maintainer,
        '--category', self.class.section,
      ]

      opts += [
        '--description', self.class.description.ui.strip
      ] if self.class.description

      %w[ depends provides replaces conflicts ].each do |type|
        if self.class.send(type).any?
          self.class.send(type).each do |dep|
            opts += ["--#{type}", dep]
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

  def mkbuilddir
    builddir = HOMEBREW_WORKDIR+'tmp-build'
    FileUtils.mkdir_p(builddir)
    raise "Couldn't create build sandbox" if not builddir.directory?

    begin
      wd=Dir.pwd
      Dir.chdir builddir
      yield
    ensure
      Dir.chdir wd
    end
  end
  alias :mktemp :mkbuilddir

  def maintainer
    @maintainer ||= self.class.maintainer || begin
      username = `git config --get user.name`.strip
      useremail = `git config --get user.email`.strip
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
end

class DebianSourceFormula < DebianFormula
  def build
    ENV['DEBEMAIL'] = maintainer
    safe_system 'dch', '-v', version, 'brew2deb package'
    safe_system 'dpkg-buildpackage', '-rfakeroot'
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

