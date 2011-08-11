require 'rake'
require 'rake/tasklib'
require 'brew2deb'

module Brew2Deb
  class BuildTask < Rake::TaskLib
    def initialize(formula)
      @name = File.basename(formula)

      @env = Env.new(:formula => formula)

      yield @env if block_given?

      define
    end

    def define
      task @name do
        Brew2Deb.send(:build, @env)
      end
    end
  end
end
