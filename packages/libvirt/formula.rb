class LibVirt < DebianFormula
  homepage 'http://www.libvirt.org'
  url 'http://libvirt.org/sources/stable_updates/libvirt-0.9.11.4.tar.gz'
  sha256 'f3e16a62dff9720e1541da5561f448853e9821baa4622a0064dc28589eebed45'

  name 'libvirt'
  section 'libs'
  version '0.9.11.4+github1'
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
