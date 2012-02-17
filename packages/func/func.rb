class Func < DebianFormula
  homepage 'https://fedorahosted.org/func/'
  url 'https://fedorahosted.org/releases/f/u/func/func-0.28.tar.gz'
  md5 '332e35c4bf6ac838df3fa8cf00732172'

  name 'func'
  version '0.28.0'
  description 'Secure remote command execution framework and tools'
  section 'utils'
  arch 'all'

  build_depends 'python'
  depends 'python', 'python-yaml', 'certmaster'

  def build
    inreplace 'init-scripts/funcd', 'Required-Start: network', 'Required-Start: networking'

    sh 'python', 'setup.py', 'build'
  end

  def install
    sh 'python', 'setup.py', 'install', '--install-layout=deb', "--root=#{destdir}"
  end
end
