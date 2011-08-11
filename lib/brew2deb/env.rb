module Brew2Deb
  class Env < OpenStruct
    def self.defaults
      {
        :action       => :build,
        :architecture => 'i386',
        :base_dir     => Pathname.new(Dir.pwd),
      }
    end

    def self.new(attrs = {})
      super(defaults.merge(attrs))
    end

    def build_dir
      super || begin
        base_dir + 'tmp-build'
      end
    end

    def install_dir
      super || begin
        base_dir + 'tmp-install'
      end
    end

    def homebrew_dir
      super || begin
        base_dir + 'homebrew'
      end
    end

    def homebrew_library_dir
      homebrew_dir + 'Library/Homebrew'
    end

    def package_dir
      super || begin
        base_dir + 'pkg'
      end
    end
  end
end
