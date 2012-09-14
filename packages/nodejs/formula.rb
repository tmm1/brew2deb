class NodeJS < DebianFormula
  url 'http://nodejs.org/dist/v0.8.9/node-v0.8.9.tar.gz'
  head 'https://github.com/joyent/node.git'
  homepage 'http://nodejs.org/'
  md5 '5470b3951a3b2684cfa71027801bd19d'

  section 'interpreters'
  name 'nodejs'
  version '0.8.9+github1'
  description 'Evented I/O for V8 JavaScript'

  build_depends \
    'libssl-dev',
    'g++',
    'python'

  depends \
    'openssl'

  def build
    configure \
      :prefix => prefix
    make
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end
