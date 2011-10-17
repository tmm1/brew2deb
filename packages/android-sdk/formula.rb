class AndroidSDK < DebianFormula
  homepage 'http://developer.android.com/sdk/index.html'
  url 'http://dl.google.com/android/android-sdk_r13-linux_x86.tgz'
  md5 'd80d7530a46c665644ae76084a9a0dc4'

  name 'android-sdk'
  version 'r13+github1'
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
