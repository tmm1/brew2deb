class S3cmd < DebianFormula
  url 'https://github.com/s3tools/s3cmd.git'

  name 's3cmd'
  section 'utils'
  version '1.1.0-master+github1'
  description 'command-line Amazon S3 client'

  build_depends 'python'
  depends 'python'
  conflicts 'python-django'

  def patches
    [
      # https://github.com/s3tools/s3cmd/pull/38
      'patches/38.patch'
    ]
  end

  def build
    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', "--prefix=#{prefix}"
  end
end
