class Ruby < DebianFormula
  section 'interpreters'

  source 'http://production.cf.rubygems.org/rubygems/rubygems-1.8.23.tgz'
  source 'https://rubygems.org/downloads/bundler-1.1.3.gem'
  source 'https://rubygems.org/downloads/rake-0.9.2.2.gem'
  source 'https://rubygems.org/downloads/rbenv-autohash-0.1.0.gem'

  def prefix
    current_pathname_for("usr/share/rbenv/versions/#{self.class.name.gsub('rbenv-','')}")
  end

  def post_install
    # clean up environment
    (ENV.keys.grep(/^rvm/) + %w( RUBYOPT RUBYLIB GEM_HOME GEM_PATH MY_RUBY_HOME )).each do |env|
      ENV.delete(env)
    end
    ENV['PATH'] = "#{prefix/'bin'}:#{ENV['PATH']}"

    # paths to installed bins
    install_rubygems
    install_rake
    install_bundler
    install_rbenv_autohash
  end

  def install_rubygems
    setup_rubylib

    # install rubygems
    chdir(builddir/'rubygems-1.8.23') do
      sh prefix/'bin/ruby', 'setup.rb', '--no-ri', '--no-rdoc'
    end

    fix_shebangs 'gem'
  end

  def install_rake
    setup_rubylib

    install_gem builddir/'rake-0.9.2.2.gem'
    fix_shebangs 'rake'
  end

  def install_bundler
    setup_rubylib

    install_gem builddir/'bundler-1.1.3.gem'
    fix_shebangs 'bundle'
  end

  def install_rbenv_autohash
    setup_rubylib

    install_gem builddir/'rbenv-autohash-0.1.0'
  end

  def install_gem(name)
    sh prefix/'bin/ruby', prefix/'bin/gem', 'install', '--no-ri', '--no-rdoc', name
  end

  def fix_shebangs(*args)
    args.each do |exe|
      inreplace(prefix/'bin'/exe, destdir, '')
    end
  end

  def setup_rubylib
    ENV.delete 'RUBYLIB'
    pre = prefix.to_s.gsub(destdir, '')
    ENV['RUBYLIB'] = rubylib.gsub(pre, prefix)
  end

  def rubylib
    rubylib = `#{prefix/'bin/ruby'} -e "puts $:.join(':')"`.strip
    raise unless $?.exitstatus == 0
    rubylib
  end

  def postinst
    "
      #!/bin/sh
      set -e
      /usr/bin/rbenv rehash
    ".ui
  end
end
