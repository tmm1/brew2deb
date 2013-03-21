class Ipxe < DebianFormula
  url 'git://git.ipxe.org/ipxe.git', :sha => '1920aa43764981597da57616cdb75c040d730712'
  name 'ipxe'
  version '1.0.0+git-4.1920aa4-0github1'

  def build
    chdir 'src' do
      inreplace 'Makefile.housekeeping' do |f|
        f.gsub!(/^.*git\/index.*$/, '')
      end
      make 'bin/ipxe.lkrn'
    end
  end

  def install
    (prefix/'lib'/'ipxe').install_p 'src/bin/ipxe.lkrn'
  end
end
