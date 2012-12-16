require 'yarv'

class TCSEncodingFix < YARV
  url 'git://github.com/thecodeshop/ruby', :sha => 'origin/tcs-ruby_1_9_3'
  homepage 'https://github.com/thecodeshop/ruby/wiki'

  name 'rbenv-1.9.3-p194+tcs+tcmalloc+encfix'
  section 'interpreters'
  version '1.0.0'
  description 'The YARV Ruby virtual machine + TCS patches'

  build_depends \
    'google-perftools (>= 1.8), google-perftools (<= 1.9)'

  depends \
    'google-perftools (>= 1.8), google-perftools (<= 1.9)'

  def patches
    ['patches/gc-tcs.patch', 'patches/tcs-process-kill.patch', 'patches/tcs-encfix.patch']
  end

  def build
    ENV['LIBS'] = '-ltcmalloc_minimal'
    sh 'autoconf'
    super
  end
end
