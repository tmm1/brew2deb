class ElfUtils < DebianFormula
  homepage 'https://fedorahosted.org/elfutils/'
  url 'https://fedorahosted.org/releases/e/l/elfutils/0.152/elfutils-0.152.tar.bz2'
  md5 '39739ed58a0fa1862eff8735f111fe5c'

  name 'elfutils'
  section 'libs'
  version '0.152+github1'
  description 'library to read and write ELF files'

  conflicts 'libelfg0', 'libelfg0-dev', 'libelf1', 'libelf-dev'
  replaces  'libelf1', 'libelf-dev'
  provides  'libelf1', 'libelf-dev'

  def patches
    {:p1 => 'https://fedorahosted.org/releases/e/l/elfutils/0.152/elfutils-portability.patch'}
  end

  def build
    configure :prefix => prefix, :program_prefix => 'eu-'
    make
  end
end
