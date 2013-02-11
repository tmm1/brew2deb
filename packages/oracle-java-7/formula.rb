class OracleJava7 < DebianSourceFormula
  url 'https://github.com/rraptorr/oracle-java7.git'

  version "7.13-1+github1"

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

    sh('dpkg-buildpackage', '-uc', '-us')
  end

  def download_jdk
    wget_download(jdk_url, jdk_cookie)
  end

  def download_jce
    url = "http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip"

    wget_download(url, jce_cookie)
  end

  def wget_download(url, cookie)
    command = %w[wget --no-check-certificate --continue --quiet]
    command << '--header' << "'#{cookie}'"
    command << url

    # sh is doing some crazy escaping that fucks up wget
    %x(#{command.join(' ')})
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

  def java_version
    version[/^(\d+)\./, 1]
  end

  def java_update
    version[/\d+\.(\d+)-/, 1]
  end

  def java_arch
    case %x{uname -m}.chomp
      when 'x86_64' then 'x64'
      else 'i586'
    end
  end

  def jdk_url
    # checkout http://www.oracle.com/technetwork/java/javase/downloads/index.html for the "b" number
    b_number = "20"

    "http://download.oracle.com/otn-pub/java/jdk/#{java_version}u#{java_update}-b#{b_number}/jdk-#{java_version}u#{java_update}-linux-#{java_arch}.tar.gz"
  end
end
