class Pstree < DebianFormula
  homepage 'http://www.thp.uni-duisburg.de/pstree/'
  url 'git://github.com/tmm1/pstree', :sha => '08531ba'

  name 'gpstree'
  version '2.33+github1'
  description 'a better pstree than psmisc'

  def build
    make 'pstree'
  end

  def install
    bin.install_p 'pstree', 'gpstree'
  end
end
