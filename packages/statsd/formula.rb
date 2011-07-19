class Statsd < DebianFormula
  url 'https://github.com/etsy/statsd.git', :sha => '116dfe3'

  name 'statsd'
  version '0.1.0'
  section 'devel'
  description 'Stats aggregation daemon'

  depends \
    'nodejs',
    'graphite'

  def build
  end

  def install
    (share/'statsd').install ['stats.js', 'config.js']

    (etc/'statsd').mkpath
    open etc/'statsd/conf.js', 'w' do |f|
      f.puts %[
        {
          graphitePort: 2003
        , graphiteHost: "localhost"
        , port: 8125
        }
      ].ui
    end

    (etc/'init.d').install_p workdir/'init.d-statsd', 'statsd'
  end
end
