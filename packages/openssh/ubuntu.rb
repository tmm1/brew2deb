require './formula'

class OpenSSH
  url 'http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_5.8p1-1ubuntu3.dsc'
  md5 'cd5aabb2ae7aff9745be208378cb5381'
  version '1:5.8p1-1ubuntu3+github1'

  def patches
    [
      'sjg-key-verification-plugin-oneiric.patch',
    ]
  end
end
