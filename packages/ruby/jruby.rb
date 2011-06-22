class RubyJRuby < DebianFormula
  homepage 'http://www.jruby.org/'
  url 'http://jruby.org.s3.amazonaws.com/downloads/1.6.2/jruby-bin-1.6.2.tar.gz', :as => 'jruby-1.6.2.tar.gz'
  md5 'a46f978c24a208717023bb4b8995c678'

  name 'ruby-jruby'
  section 'interpreters'
  version '1.6.2'
  description 'The JRuby Ruby virtual machine'

  depends \
    'sun-java6-jre'

  def build
    # Remove Windows files
    rm Dir['bin/*.{bat,dll,exe}']
  end

  def install
    (prefix+'jruby').install Dir['*']

    bin.mkpath
    Dir["#{prefix}/jruby/bin/*"].each do |f|
      dst = bin+File.basename(f)
      f = Pathname.new(f)
      ln_s f.relative_path_from(dst), dst
    end
  end
end
