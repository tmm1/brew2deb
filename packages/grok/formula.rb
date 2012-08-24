class Grok < DebianFormula
  homepage 'http://code.google.com/p/semicomplete/wiki/Grok'
  url 'http://semicomplete.googlecode.com/files/grok-1.20110630.1.tar.gz'
  md5 'cb91edadab0f5cf452c53b15bdfc2589'

  name 'grok'
  version '1.20110630.1+github1'
  section 'libs'
  description 'A powerful pattern-matching/reacting tool.'

  build_depends \
    'bison',
    'ctags',
    'flex',
    'gperf',
    'libevent-dev',
    'libtokyocabinet-dev',
    'libpcre3-dev'

  depends \
    'libtokyocabinet8'

  def build
    make
  end

end
