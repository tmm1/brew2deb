class S3cmd < DebianFormula
  url 'https://github.com/s3tools/s3cmd.git', :tag => 'a0f0f4fd84f528fd3fdb9df9b2c5414f01ad347e'

  name 's3cmd'
  section 'utils'
  version '1.5.0-alpha1+github5'
  description 'command-line Amazon S3 client'

  build_depends 'python'
  depends 'python'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    version = `python --version 2>&1`.strip
    extra = []

    extra << '--install-layout=deb' unless version.include? '2.5'
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}", *extra
  end
end
