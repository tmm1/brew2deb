class Ruby < DebianFormula
  section 'interpreters'

  source 'http://production.cf.rubygems.org/rubygems/rubygems-1.6.2.tgz'
  source 'https://rubygems.org/downloads/bundler-1.0.15.gem'

  def post_install
    # clean up environment
    (ENV.keys.grep(/^rvm/) + %w( RUBYOPT RUBYLIB GEM_HOME GEM_PATH MY_RUBY_HOME )).each do |env|
      ENV.delete(env)
    end
    ENV['PATH'] = "#{prefix/'bin'}:#{ENV['PATH']}"

    # paths to installed bins
    ruby = prefix/'bin/ruby'
    gem = prefix/'bin/gem'
    install_rubygems_and_bundler
  end

  def install_rubygems_and_bundler
    # setup RUBYLIB
    rubylib = `#{ruby} -e "puts $:.join(':')"`.strip
    raise unless $?.exitstatus == 0

    pre = prefix.to_s.gsub(destdir, '')
    ENV['RUBYLIB'] = rubylib.gsub(pre, prefix)

    # install rubygems
    chdir(builddir/'rubygems-1.6.2') do
      sh ruby, 'setup.rb', '--no-ri', '--no-rdoc'
    end

    # install bundler
    sh ruby, gem, 'install', '--no-ri', '--no-rdoc', builddir/'bundler-1.0.15.gem'

    # fix shebangs
    %w[ gem bundle ].each do |exe|
      inreplace(prefix/'bin'/exe, destdir, '')
    end
  end
end
