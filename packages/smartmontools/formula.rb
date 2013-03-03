class Smartmontools < DebianSourceFormula
  url 'http://archive.ubuntu.com/ubuntu/pool/main/s/smartmontools/smartmontools_5.43-0ubuntu1.dsc'
  md5 'dffe37aceda3a2a06bb3c0b5a8a03615'
  version '5.43-0ubuntu1'
  build_depends %w(quilt libcap-ng-dev)
end
