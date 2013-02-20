class S3cmd < DebianFormula
  url 'https://github.com/sshirokov/s3cmd.git', :tag => 'v1.5.0-alpha1-github1'

  name 's3cmd'
  section 'utils'
  version '1.5.0-alpha1+github1'
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
