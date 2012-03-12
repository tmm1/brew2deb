class S3cmd < DebianFormula
  url 'http://sourceforge.net/projects/s3tools/files/s3cmd/1.1.0-beta3/s3cmd-1.1.0-beta3.tar.gz/download'
  md5 'b27d9a5d5b5e32798947a3661e67e537'

  name 's3cmd'
  section 'utils'
  version '1.1.0-beta3+github'
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
