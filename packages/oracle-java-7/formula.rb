# checkout http://www.oracle.com/technetwork/java/javase/downloads/index.html for the "build" number
class OracleJava7 < DebianSourceFormula
  url 'https://github.com/rraptorr/oracle-java7.git'

  version "7.15-3+github1"

  provides \
    'oracle-java7-jre',
    'oracle-java7-bin',
    'oracle-java7-plugin',
    'oracle-java7-fonts',
    'oracle-java7-jdk',
    'oracle-java7-source',
    'oracle-java7-javadb'

  build_depends \
    'lsb-release',
    'unzip',
    'bzip2',
    'patch',
    'libasound2',
    'unixodbc',
    'libx11-6',
    'libxext6',
    'libxi6',
    'libxt6',
    'libxtst6',
    'libxrender1'

  def build
    download_jdk
    download_jce

    fix_version

    sh('dpkg-buildpackage', '-uc', '-us')
  end

  def download_jdk
    wget_download(jdk_url, jdk_cookie)
  end

  def download_jce
    url = "http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip"

    wget_download(url, jce_cookie)
  end

  def wget_download(url, cookie_header)
    sh 'wget', '--no-check-certificate',
               '--continue',
               '--quiet',
               '--header', cookie_header,
               '--output-document', File.basename(url),
               url
  end

  def cookie_header(cookie)
    "Cookie:#{cookie}"
  end

  def jdk_cookie
    cookie_header("oraclelicensejdk-#{java_version}u#{java_update}-oth-JPR=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com")
  end

  def jce_cookie
    cookie_header("oraclelicensejce-7-oth-JPR=accept-securebackup-cookie;gpw_e24=http://edelivery.oracle.com")
  end

  def version_parts
    version.match(/^(\d+)\.(\d+)-(\d+)\+/)
  end

  def java_version
    version_parts[1]
  end

  def java_update
    version_parts[2]
  end

  def java_build
    "%02d" % version_parts[3]
  end

  def java_arch
    case %x{uname -m}.chomp
      when 'x86_64' then 'x64'
      else 'i586'
    end
  end

  def jdk_url
    "http://download.oracle.com/otn-pub/java/jdk/#{java_version}u#{java_update}-b#{java_build}/jdk-#{java_version}u#{java_update}-linux-#{java_arch}.tar.gz"
  end

  def fix_version
    current_version = %x{dpkg-parsechangelog}.grep(/^Version: /).first[/^Version: (\d+\.\d+\-\d+)/, 1]

    sh('sed', '-i', "1 s/#{current_version}/#{version}/", 'debian/changelog')
  end
end
