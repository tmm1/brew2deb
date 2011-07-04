class NodeJS < DebianFormula
  url 'http://nodejs.org/dist/node-v0.4.8.tar.gz'
  head 'https://github.com/joyent/node.git'
  homepage 'http://nodejs.org/'
  md5 '22c9f69370069fe81678592cc8ae48f1'

  section 'interpreters'
  name 'nodejs'
  version '0.4.8+github1'
  description 'Evented I/O for V8 JavaScript'

  build_depends \
    'libssl-dev',
    'g++',
    'python'

  depends \
    'openssl'

  def build
    inreplace 'wscript' do |s|
      s.gsub! '/usr/local', '/usr'
      s.gsub! '/opt/local/lib', '/usr/lib'
    end

    configure \
      :prefix => prefix,
      :debug => true
    make
  end

  def install
    make :install, 'DESTDIR' => destdir
  end
end
