class AndroidSDK < DebianFormula
  homepage 'http://developer.android.com/sdk/index.html'
  url 'http://dl.google.com/android/android-sdk_r15-linux.tgz'
  md5 'f529681fd1eda11c6e1e1d44b42c1432'

  name 'android-sdk'
  version 'r15+github1'

  description 'Android SDK'
  section 'devel'
  arch 'all'

  depends \
    'ant',
    'sun-java6-jdk',
    'ia32-libs'

  def build
  end

  def install
    (share/'android-sdk').install_p '.'
  end

  def postinst
    "
      #!/bin/sh
      set -e

      /usr/share/android-sdk/tools/android update sdk --force --no-ui
    ".ui
  end
end
