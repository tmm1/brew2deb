module Brew2Deb
  module CLI
    def self.run(argv = ARGV)
      options = {}

      if argv.empty?
        options[:formula] = 'formula.rb'
      elsif argv.first !~ /^-/
        options[:formula] = argv.shift
      end

      parse(options, argv)

      env = Env.new(options)
      Brew2Deb.send(env.action, env)
    end

    def self.parse(options, argv)
      optparse = OptionParser.new do |opts|
        opts.on('-a', '--architecture', 'i386 or amd64') do |arch|
          options[:architecture] = arch
        end

        opts.on('-b', '--build', 'Build the formula (DEFAULT)') do
          options[:action] = :build
        end

        opts.on('-c', '--clean', 'Clean the package.') do
          options[:action] = :clean
        end

        opts.on('-d', '--dir DIR', 'Working directory. Defaults to pwd.') do |dir|
          options[:base_dir] = Pathname.new(dir)
        end

        opts.on('-e', '--cache-dir DIR', 'Cache directory. Defaults to pwd/tmp-cache.') do |dir|
          options[:cache_dir] = Pathname.new(dir)
        end

        opts.on('-f', '--formula FILE', 'The homebrew formula file.') do |file|
          options[:formula] = file
        end

        opts.on('-i', '--install-dir DIR', 'Build directory. Defaults to pwd/tmp-install.') do |dir|
          options[:install_dir] = Pathname.new(dir)
        end

        opts.on('-o', '--homebrew-dir DIR', 'Homebrew installation dir.') do |dir|
          options[:homebrew_dir] = Pathname.new(dir)
        end

        opts.on('-p', '--package-dir DIR', 'Package directory. Defaults to pwd/pkg.') do |dir|
          options[:package_dir] = Pathname.new(dir)
        end

        opts.on('-u', '--build-dir DIR', 'Build directory. Defaults to pwd/tmp-build.') do |dir|
          options[:build_dir] = Pathname.new(dir)
        end

        opts.on('-t', '--output-dir DIR', 'Output directory. Defaults to pwd.') do |dir|
          options[:output_dir] = Pathname.new(dir)
        end

        opts.on('-v', '--verbose') do
          options[:verbose] = true
        end
      end

      optparse.parse(argv)
    end
  end
end
