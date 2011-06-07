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
      FileUtils.rm_rf(f.send(:destdir))
      f.install

      f.send :ohai, 'Packaging into a .deb'
      f.package
    end
  end

  def package
    maintainer = self.class.maintainer || begin
      username = `git config --get user.name`.strip
      useremail = `git config --get user.email`.strip
      "#{username} <#{useremail}>"
    end

    Dir.chdir HOMEBREW_WORKDIR do
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
        '--description', self.class.description.ui.strip
      ]

      %w[ depends provides replaces ].each do |type|
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
