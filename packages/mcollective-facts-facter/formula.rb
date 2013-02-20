class McollectiveFactsFacter < DebianSourceFormula
  name 'mcollective-facts-facter'
  url 'https://raw.github.com/puppetlabs/mcollective-plugins/master/facts/facter/facter_facts.rb'
  md5 '3fc956039bafd88a15ea6e6d0e2c13c4'
  description 'Facter integration plugin for MCollective'
  version '1:1.26-1+github1'
  depends 'mcollective'

  def build
  end

  def install
    (prefix/'share/mcollective/plugins/mcollective/facts').install 'facter_facts.rb'
  end
end
