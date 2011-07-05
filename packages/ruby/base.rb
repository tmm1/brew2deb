class Ruby < DebianFormula
  section 'interpreters'

  source 'http://production.cf.rubygems.org/rubygems/rubygems-1.8.5.tgz'
  source 'https://rubygems.org/downloads/bundler-1.0.15.gem'

  def post_install
    # clean up environment
    (ENV.keys.grep(/^rvm/) + %w( RUBYOPT RUBYLIB GEM_HOME GEM_PATH MY_RUBY_HOME )).each do |env|
      ENV.delete(env)
    end
    ENV['PATH'] = "#{destdir}/usr/bin:#{ENV['PATH']}"

    # paths to installed bins
    ruby = destdir/'usr/bin/ruby'
    gem = destdir/'usr/bin/gem'

    # setup RUBYLIB
    rubylib = `#{ruby} -e "puts $:.join(':')"`.strip
    raise unless $?.exitstatus == 0
    ENV['RUBYLIB'] = rubylib.gsub('/usr', destdir/'usr')

    # install rubygems
    chdir(builddir/'rubygems-1.8.5') do
      sh ruby, 'setup.rb', '--no-ri', '--no-rdoc'
    end

    # install bundler
    sh ruby, gem, 'install', '--no-ri', '--no-rdoc', builddir/'bundler-1.0.15.gem'

    # fix shebangs
    %w[ gem bundle ].each do |exe|
      inreplace(destdir/'usr/bin'/exe, destdir, '')
    end
  end
end
