class S3cmd < DebianFormula
  url 'https://github.com/s3tools/s3cmd.git', :tag => 'a0f0f4fd84f528fd3fdb9df9b2c5414f01ad347e'

  name 's3cmd'
  section 'utils'
  version '1.5.0-alpha1+github3'
  description 'command-line Amazon S3 client'

  build_depends 'python'
  depends 'python'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
