require './formula'

class OpenSSH
  url 'http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_5.8p1-1ubuntu3.dsc'
  md5 'cd5aabb2ae7aff9745be208378cb5381'
  version '1:5.8p1-1ubuntu3+github1'

  def patches
    [
      'mysql_patch_5.8-p1-1.patch',
      'ubuntu-enable_mysql_keys.patch',
    ]
  end
end
