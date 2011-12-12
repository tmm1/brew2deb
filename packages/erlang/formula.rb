require 'formula'

class Erlang < DebianFormula
  homepage 'http://www.erlang.org'
  # Download tarball from GitHub; it is served faster than the official tarball.
  url 'https://github.com/erlang/otp/tarball/OTP_R14B04'
  md5 'f6cd1347dfb6436b99cc1313011a3d24'

  name 'erlang-base'
  version '1:14.b.4-github1'
  section 'main'
  description 'Concurrent, real-time, distributed functional language'

  depends \
    'libncurses5-dev',
    'openssl',
    'libssl-dev',
    'libc6-dev-i386'

  # We can't strip the beam executables or any plugins, there isn't really
  # anything else worth stripping and it takes a really, long time to run
  # `file` over everything in lib because there is almost 4000 files (and
  # really erlang guys! what's with that?! Most of them should be in share/erlang!)
  # may as well skip bin too, everything is just shell scripts
  skip_clean ['lib', 'bin']

  def build
    ohai "Compilation may take a very long time; use `brew install -v erlang` to see progress"

    # Do this if building from a checkout to generate configure
    system "./otp_build autoconf" if File.exist? "otp_build"

    configure :enable_debug => true,
            :prefix => prefix,
            :enable_kernel_poll => true,
            :enable_treads => true,
            :enable_dynamic_ssl_lib => true,
            :enable_smp_support => true

    make
  end

  def test
    `#{bin}/erl -noshell -eval 'crypto:start().' -s init stop`

    # This test takes some time to run, but per bug #120 should finish in
    # "less than 20 minutes". It takes a few minutes on a Mac Pro (2009).
    if ARGV.include? "--time"
      `#{bin}/dialyzer --build_plt -r #{lib}/erlang/lib/kernel-2.14.1/ebin/`
    end
  end
end
