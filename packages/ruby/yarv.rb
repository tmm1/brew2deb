require 'mri'

class YARV < MRI
  url 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz'
  md5 '0d6953820c9918820dd916e79f4bfde8'

  name 'ruby-yarv'
  version '1.9.2-p180'
  description 'The YARV Ruby virtual machine'

  # build_depends \
  #   'libffi-dev'
  #
  # depends \
  #   'libffi5'
end
