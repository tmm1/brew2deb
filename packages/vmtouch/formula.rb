class Vmtouch < DebianFormula
  homepage 'http://hoytech.com/vmtouch/'
  url 'https://github.com/hoytech/vmtouch.git', :sha => '004b567d57'

  name 'vmtouch'
  version '1.0.0'
  description 'Portable file system cache diagnostics and control'
  section 'extra'

  def build
    safe_system 'gcc -Wall -O3 -o vmtouch vmtouch.c'
  end

  def install
    bin.install 'vmtouch'
    man8.install 'vmtouch.8'
  end
end
