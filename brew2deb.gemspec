Gem::Specification.new do |s|
  s.name    = 'brew2deb'
  s.version = '0.0.0'
  s.date    = Date.today.to_s

  s.summary = "homebrew + fpm = debian packages"
  s.description = s.summary

  s.authors  = ['Aman Gupta']
  s.email    = 'aman@tmm1.net'
  s.homepage = 'http://github.com/tmm1/brew2deb'

  s.files = Dir['lib/**/*']
  s.bindir = 'bin'
  s.default_executable = 'bin/brew2deb'

  s.add_dependency 'fpm'
end
