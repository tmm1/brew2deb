class PuppetDB < DebianSourceFormula
  url 'https://apt.puppetlabs.com/pool/squeeze/main/p/puppetdb/puppetdb_1.1.1-1puppetlabs1.dsc'
  md5 'c9c1f847e464992ce7996be2c325cd74'

  version '1.1.1+github3'

  build_depends \
    'leiningen',
    'puppet',
    'facter'
end
