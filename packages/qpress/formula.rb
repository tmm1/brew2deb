class Qpress < DebianFormula
  homepage 'http://quicklz.com'
  url 'http://www.quicklz.com/qpress-11-source.zip'
  md5 'ea2d8bc96e86e93f64a93bc546401c95'

  name 'qpress'
  version '1.1'
  section 'utils'
  description 'portable file archiver using QuickLZ'

  def build
    make
  end

  def install
    bin.install 'qpress'
  end
end
