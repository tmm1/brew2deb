class Openwsman < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/universe/o/openwsman/openwsman_2.3.6-0ubuntu1.dsc'
  md5 '964b4fcadbdba29ee05ef282b7f33869'
  version '2.3.6-0ubuntu1'

  build_depends %w(cmake libpam0g-dev libxml2-dev libcurl4-openssl-dev libcimcclient0-dev swig)
end
