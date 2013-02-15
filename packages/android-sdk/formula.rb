class AndroidSDK < DebianFormula
  homepage 'http://developer.android.com/sdk/index.html'
  url 'http://dl.google.com/android/android-sdk_r17-linux.tgz'
  md5 '14e99dfa8eb1a8fadd2f3557322245c4'

  name 'android-sdk'
  version '17+github2'

  description 'Android SDK'
  section 'devel'
  arch 'all'

  depends \
    'ant',
    'sun-java6-jdk | oracle-java7-jdk',
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

      /usr/share/android-sdk/tools/android update sdk --force --no-ui \
        --filter platform,system-image,tool,platform-tool,doc,addon-google_apis-google-8,addon-google_apis-google-15
      find /usr/share/android-sdk -type d -print0 | xargs -0 chmod 755
    ".ui
  end
end
