class Grok < DebianFormula
  homepage 'http://code.google.com/p/semicomplete/wiki/Grok'
  url 'http://semicomplete.googlecode.com/files/grok-1.20110708.1.tar.gz'
  md5 '609982f22b7919eb9280a06092a296f7'

  name 'grok'
  version '1.20110708.1+github1'
  section 'libs'
  description 'A powerful pattern-matching/reacting tool.'

  build_depends \
    'bison',
    'ctags',
    'flex',
    'gperf' 

  depends \
    'libevent-dev',
    'libpcre3-dev',
    'libtokyocabinet-dev',
    'libtokyocabinet8'

  def build
    make
  end

end
