class Zeromq < DebianFormula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-2.1.11.tar.gz'
  md5 'f0f9fd62acb1f0869d7aa80379b1f6b7'

  name 'zeromq'
  version '2.1.11'
  section 'libs'
  description '0MQ: The Intelligent Transport Layer'

  build_depends \
    'uuid-dev'

  depends \
    'libuuid1'

  conflicts 'libzmq-dev', 'libzmq0', 'libzmq1', 'zeromq-utils'

  def build
    configure :prefix => prefix, :with_pgm => true
    make
  end
end
