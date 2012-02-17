class CertMaster < DebianFormula
  homepage 'https://fedorahosted.org/certmaster/'
  url 'https://fedorahosted.org/releases/c/e/certmaster/certmaster-0.28.tar.gz'
  md5 'f5acc9ff1efa34971296e26d794c5b35'

  name 'certmaster'
  version '0.28.0'
  description 'Remote certificate distribution framework'
  section 'utils'
  arch 'all'

  build_depends 'python'
  depends 'python', 'python-openssl'

  def build
    inreplace 'init-scripts/certmaster' do |s|
      s.gsub! 'Required-Start: network', "Required-Start: networking\n# Required-Stop:"
    end

    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', '--install-layout=deb', "--root=#{destdir}"
  end
end
