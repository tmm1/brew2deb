require 'mri'

class Kiji < MRI
  url 'https://github.com/twitter/rubyenterpriseedition187-248.git', :sha => '584cdea'
  homepage 'https://github.com/twitter/rubyenterpriseedition187-248/blob/master/README-kiji'

  name 'ruby-kiji'
  section 'interpreters'
  version '0.11'
  description 'The Kiji Ruby virtual machine'

  build_depends \
    'google-perftools'

  depends \
    'google-perftools'

  def build
    ENV['CFLAGS'] = '-O2 -ggdb -Wall -fPIC -fno-builtin-malloc
     -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
     -fno-stack-protector'.gsub(/\s+/, ' ')
    ENV['LIBS'] = '-ltcmalloc_minimal'

    sh 'autoconf'
    configure :prefix => prefix, :disable_pthread => true, :disable_shared => true, :disable_ucontext => true
    make
  end
end
