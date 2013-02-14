class PuppetDB < DebianFormula
  url 'http://apt.puppetlabs.com/pool/squeeze/main/p/puppetdb/puppetdb_1.0.5.orig.tar.gz'
  md5 '1f28273691d7d22382152f6504aa00ad'

  name 'puppetdb'
  version '1.0.5+github1'
  description 'next-generation open source storage service for Puppet-produced data'
  section 'database'
  arch 'all'

  build_depends \
    'sun-java6-jdk', \
    'sbt'

  depends \
    'postgresql', \
    'sun-java6-jre'


  def build
    mv 'scripts/kestrel.sh', 'scripts/kestrel'
    sh 'chmod +x scripts/kestrel'
    inreplace 'scripts/kestrel' do |s|
      s.gsub! '/usr/local/bin', '/usr/bin'
      s.gsub! '/usr/local', '/usr/share'
      s.gsub! '.sh', ''
      s.gsub! '/opt/jdk', '/usr'
    end
  end

  def preinst
    "
    #!/bin/sh
    if ! getent passwd puppetdb  > /dev/null; then
        adduser --quiet --system --group --home /usr/share/puppetdb  \
            --no-create-home                                 \
            --gecos 'Puppet StoredConfigs daemon' \
            puppetdb
    fi

    # Create the 'puppetdb' group, if it is missing, and set the
    # primary group of the 'puppetdb' user to this group.
    if ! getent group puppetdb > /dev/null; then
         addgroup --quiet --system puppetdb
         usermod -g puppetdb puppetdb
    fi
    ".ui
  end

  def install
    (lib/'ruby/1.8/puppet').install(builddir/'puppet/lib/puppet')

    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/kestrel_2.9.2-2.4.1.jar')
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/libs')
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/config')
    (share/'kestrel/current').install(builddir/'kestrel-2.4.1/scripts')
    (etc/'init.d').install_p(builddir/'kestrel-2.4.1/scripts/kestrel')

    (var+'lib/puppetdb').mkpath
    (var+'log/puppetdb').mkpath
  end

  def postinst
    "
      #!/bin/sh
      chown -R puppet:puppet /usr/lib/ruby/1.8/puppet
      /usr/sbin/puppetdb-ssl-setup
      pw=`cat /etc/puppetdb/ssl/puppetdb_keystore_pw.txt`

      find  /etc/puppetdb/conf.d -type f | xargs chmod 640
      chown -R puppetdb:puppetdb /etc/puppetdb/conf.d/..
      chown -R puppetdb:puppetdb /usr/share/puppetdb
      chown -R puppetdb:puppetdb /var/lib/puppetdb
      chown -R puppetdb:puppetdb /var/log/puppetdb

      cat > /etc/puppetdb/conf.d/jetty.ini << EOF
[jetty]
port = 8080
ssl-host = `facter fqdn`
ssl-port = 8081
keystore = /etc/puppetdb/ssl/keystore.jks
truststore = /etc/puppetdb/ssl/truststore.jks
key-password = $pw
trust-password = $pw
EOF
    ".ui
  end
end
