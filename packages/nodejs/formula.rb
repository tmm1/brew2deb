class NodeJS < DebianFormula
  url 'http://nodejs.org/dist/v0.8.11/node-v0.8.11.tar.gz'
  head 'https://github.com/joyent/node.git'
  homepage 'http://nodejs.org/'
  md5 '23cb6d6a5c3949ac73df3c6b330e834d'

  section 'interpreters'
  name 'nvm-0.8.11'
  version '1.0.0'
  description 'Evented I/O for V8 JavaScript'

  build_depends \
    'libssl-dev',
    'g++',
    'python',
    'python-simplejson'

  depends \
    'openssl'

  def prefix
    current_pathname_for("usr/share/nvm/#{self.class.name.gsub('nvm-','')}")
  end

  def build
    inreplace 'tools/install.py', 'import json', 'import simplejson as json'
    configure \
      :prefix => prefix
    make
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end
