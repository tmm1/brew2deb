class Pstree < DebianFormula
  homepage 'http://www.thp.uni-duisburg.de/pstree/'
  url 'git://github.com/tmm1/pstree', :sha => '44eb6c2'

  name 'gpstree'
  version '2.33+github2'
  description 'better than psmisc'

  def build
    make 'pstree'
  end

  def install
    bin.install_p 'pstree', 'gpstree'
  end
end
