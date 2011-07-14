class Zeromq < DebianFormula
  homepage 'http://www.zeromq.org/'
  url 'http://download.zeromq.org/zeromq-2.1.7.tar.gz'
  md5 '7d3120f8a8fb913a7e55c57c6eb024f3'

  name 'zeromq'
  version '2.1.7'
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
