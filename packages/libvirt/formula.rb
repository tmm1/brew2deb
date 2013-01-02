class LibVirt < DebianFormula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/libvirt-1.0.1.tar.gz'
  sha256 '4a16c76c46ebc41a6514082b5d95b5d5a0868e7a8cc00ab2e6cc1a23ec6b5a3b'


  name 'libvirt'
  section 'libs'
  version '1.0.1+github1'
  description 'libvirt is a library to interact with various virtualization technologies'

  conflicts 'libvirt-bin'
  replaces  'libvirt-bin'
  provides  'libvirt-bin'

  build_depends  'libxml2-dev', 'libgnutls-dev', 'libdevmapper-dev', 'libcurl4-gnutls-dev', 'python-dev', 'libnl-dev'
  depends        'libxml2', 'libgnutls26', 'libdevmapper', 'libcurl3-gnutls', 'libnl1'

  def patches
    [ 'prevent-jvm-segfault.patch',
      'esx-thin-provision.patch']
  end

  def build
  end

  def install
    args = ["--prefix=#{prefix}",
            "--with-esx",
            "--with-remote",
            "--with-test",
            "--with-vbox",
            "--with-vmware",
            "--with-kvm",
            "--without-qemu",
            "--without-xen",
           ]

    sh "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    sh "make"
    sh "make install"

  end

end
