class CollectdCarbon < DebianFormula
  url 'https://github.com/indygreg/collectd-carbon.git', 
    :tag => '3fbc6b84a99b4e0abea7970185fa4bb5eccfce62'
  homepage 'https://github.com/indygreg/collectd-carbon'

  name 'collectd-carbon'
  version '0.0+github1'
  section 'utils'
  description 'Carbon write plugin for collectd'

  depends 'python', 'collectd'

  def build
  end

  def install
    (prefix/'lib/collectd/python').install_p('carbon_writer.py')
    ['README.md', 'NOTICE'].each do |f|
      (prefix/'share/doc/collectd-carbon').install_p(f)
    end
  end
end
