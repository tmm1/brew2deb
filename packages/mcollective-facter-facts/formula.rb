class MCollectiveFacterFacts < DebianSourceFormula
  name 'mcollective-facter-facts'
  url 'http://apt.puppetlabs.com/pool/squeeze/main/m/mcollective-facter-facts/mcollective-facter-facts_1.0.0-1.dsc'
  md5 '26c2169dfa998b2162d53d0c5a0bcb5f'
  description 'Facter integration plugin for MCollective'
  version '1.0.0-1+github1'

  depends 'mcollective-common', 'ruby'
end
