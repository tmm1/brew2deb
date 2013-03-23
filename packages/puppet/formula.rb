class Puppet < DebianFormula
  url 'https://github.com/jfryman/massive-octo-bear.git'

  name 'puppet-dummy'
  version '2.7.21'
  description "Empty dummy package for Puppet"

  provides "puppet"
end
