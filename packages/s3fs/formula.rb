class S3fs < DebianFormula
  homepage 'http://code.google.com/p/s3fs/'
  url 'http://s3fs.googlecode.com/files/s3fs-1.62.tar.gz'
  sha1 '1b86d2b3f52dc490e138dddf469d4044c573c632'

  name 's3fs'
  version '1.62'
  section ''
  description 'FUSE-based file system backed by Amazon S3'

  build_depends \
    'libfuse-dev (>= 2.8.4)',
    'libcurl4-openssl-dev',
    'libxml2-dev'

end
