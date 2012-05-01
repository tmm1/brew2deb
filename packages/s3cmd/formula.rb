class S3cmd < DebianFormula
  url 'https://github.com/s3tools/s3cmd.git'

  name 's3cmd'
  section 'utils'
  version '1.1.0-master+github2'
  description 'command-line Amazon S3 client'

  build_depends 'python'
  depends 'python'
  conflicts 'python-django'

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
