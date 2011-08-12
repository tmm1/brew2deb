require 'fileutils'
require 'optparse'
require 'ostruct'
require 'tempfile'

require 'fpm'
require "fpm/program"

module Brew2Deb
  def self.clean(env)
    [env.build_dir, env.install_dir].each do |dir|
      FileUtils.rm_rf dir, :verbose => env.verbose
    end
  end

  def self.build(env)
    load_hacks!(env)

    formula = load_formula(env)

    formula.package!(env)
  end

  def self.load_hacks!(env)
    load_homebrew(env)
    load_extensions
  end

  def self.load_homebrew(env)
    Kernel.eval("::HOMEBREW_WORKDIR = Pathname.new('#{env.base_dir}')")
    Kernel.eval("::HOMEBREW_CACHE = Pathname.new('#{env.cache_dir}')")

    $:.unshift(env.homebrew_library_dir)
    require 'global'
    require 'formula'
  end

  def self.load_extensions
    require 'brew2deb/ext/string'
    require 'brew2deb/ext/formula'
    require 'brew2deb/ext/debian_formula'
    require 'brew2deb/ext/debian_source_formula'
  end

  def self.load_formula(env)
    load env.formula
    eval(File.read(env.formula)[/class (\w+)/, 1])
  end
end

require 'brew2deb/cli'
require 'brew2deb/env'
