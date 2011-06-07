$:.unshift File.expand_path('../../../lib', __FILE__)
require 'debian_formula'

class DebianSourceFormula < DebianFormula
  def build
    safe_system 'dch', '-v', version
    safe_system 'dpkg-buildpackage', '-rfakeroot'
  end

  def install
  end

  def package
  end
end

class OpenSSH < DebianSourceFormula
  url 'http://ftp.de.debian.org/debian/pool/main/o/openssh/openssh_5.1p1-5.dsc'
  md5 '338282d6bc34e9ea227862557a042818'
  version '1:5.1p1-6~github1'

  def patches
    'mysql_patch_5.2-p1-1.patch'
  end
end

if __FILE__ == $0
  Object.__send__ :remove_const, :HOMEBREW_CACHE
  HOMEBREW_WORKDIR = Pathname.new(File.expand_path('../', __FILE__))
  HOMEBREW_CACHE = HOMEBREW_WORKDIR+'cache'
  FileUtils.mkdir_p(HOMEBREW_CACHE)

  OpenSSH.package!
end
