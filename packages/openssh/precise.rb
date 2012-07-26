require './formula'

class OpenSSH
  url 'http://archive.ubuntu.com/ubuntu/pool/main/o/openssh/openssh_5.9p1-5ubuntu1.dsc'
  md5 'b67b3deb54e72a522153f5af33ef289e'
  version '1:5.9p1-5ubuntu1+github2'

  def patches
    [
      'sjg-key-verification-plugin.patch'
    ]
  end

  def patch
    super
    File.open('debian/source/options','w') {|f| f.puts 'auto-commit' }
  end
end
