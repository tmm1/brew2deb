class NPM < DebianFormula
  head 'git://github.com/isaacs/npm.git', :tag => 'v1.0.12'
  homepage 'http://npmjs.org'

  build_depends 'nodejs'
  depends 'nodejs'

  name 'npm'
  section 'devel'
  version '1.0.12+github1'
  description 'A package manager for node'

  def build
  end

  def install
    lib = (prefix + 'lib')
    lib.mkpath
    chdir lib do
      sh "node #{builddir}/npm--git/cli.js install #{builddir}/npm--git"
    end

    bin = (prefix + 'bin')
    bin.mkpath
    %w[ npm npm-g npm_g ].each do |exe|
      FileUtils.symlink '../lib/node_modules/npm/bin/npm.js', (bin+exe)
    end

    FileUtils.rm_rf(lib+'node_modules/.bin')

    man = prefix+'share/man/man1'
    man.mkpath
    Dir[lib+'node_modules/npm/man1/*.1'].each do |file|
      dst = File.basename(file)
      dst = "npm-#{dst}" unless dst == 'npm.1'

      FileUtils.cp file, man+dst
    end
  end
end
