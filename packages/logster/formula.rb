class Logster < DebianFormula
  url 'https://github.com/etsy/logster.git', 
    :tag => '286f72e1c32e06076203f5883e722bba60110e8e'
  homepage 'https://github.com/etsy/logster'

  name 'logster'
  version '0.1+github1'
  section 'utils'
  description 'Parse log files and generate metrics for Graphite and Ganglia'

  depends 'python', 'logcheck'

  def build
  end

  def install
    (prefix/'sbin').install_p('logster')
    (prefix/'share/logster').install_p('logster_helper.py')
    (prefix/'share/logster').install Dir['parsers/*']
    (prefix/'share/doc/logster').install_p('README')
    (var/'log/logster').mkpath
  end
end
