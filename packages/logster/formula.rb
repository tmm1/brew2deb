class Logster < DebianFormula
  url 'https://github.com/etsy/logster.git', 
    :tag => 'cc0eb8e44f739a589779ebbf2dfcc92e498fe37e'
  homepage 'https://github.com/etsy/logster'

  name 'logster'
  version '0.0+github1'
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
