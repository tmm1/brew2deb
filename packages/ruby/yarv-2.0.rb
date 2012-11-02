require 'yarv'

class YARV2 < YARV
  url 'http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-preview1.tar.gz'
  homepage 'http://www.ruby-lang.org/'
  md5 'c7d73f3ddb6d25e7733626ddbad04158'

  name 'rbenv-2.0.0-pre1'
  section 'interpreters'
  version '1.0.0'
  description 'The MRI Ruby virtual machine'

  depends 'rbenv'
  provides! 'rbenv-2.0'
end
