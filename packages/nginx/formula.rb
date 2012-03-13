class Nginx < DebianFormula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.0.13.tar.gz'
  md5 '58360774e4875e8fc4c4286448cb54d0'

  source 'https://github.com/nickh/chunkin-nginx-module.git', :sha => '140d61c3'
  source 'https://github.com/agentzh/headers-more-nginx-module.git', :tag => 'v0.15'
  source 'https://github.com/vkholodkov/nginx-upload-module.git', :tag => '2.2'
  source 'https://github.com/yaoweibin/nginx_syslog_patch.git', :sha => 'afeea6d'

  name 'nginx'
  version '1.0.13+github3'
  section 'httpd'
  description 'a high performance web server and a reverse proxy server'

  build_depends \
    'libpcre3-dev',
    'zlib1g-dev',
    'libssl-dev'

  provides  'nginx-full', 'nginx-common'
  replaces  'nginx-full', 'nginx-common'
  conflicts 'nginx-full', 'nginx-common'

  config_files \
    '/etc/nginx/nginx.conf',
    '/etc/nginx/mime.types',
    '/var/www/nginx-default/index.html'

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => [
       'nginx-header-leak-final.patch',
       'https://github.com/nickh/nginx/commit/2e05240b8d043125379a68957c6d6c657c48bb0a.patch',
       workdir/'src/nginx_syslog_patch.git/syslog_1.0.6.patch'
     ]}
  end

  def build
    configure \
      '--with-http_stub_status_module',
      '--with-http_ssl_module',
      '--with-http_gzip_static_module',
      '--with-pcre',
      '--with-debug',

      "--add-module=#{builddir/'chunkin-nginx-module.git'}",
      "--add-module=#{builddir/'headers-more-nginx-module.git'}",
      "--add-module=#{builddir/'nginx-upload-module.git'}",
      "--add-module=#{builddir/'nginx_syslog_patch.git'}",

      :prefix => prefix,

      :user => 'www-data',
      :group => 'www-data',

      :pid_path => '/var/run/nginx.pid',
      :lock_path => '/var/lock/nginx.lock',
      :conf_path => '/etc/nginx/nginx.conf',
      :http_log_path => '/var/log/nginx/access.log',
      :error_log_path => '/var/log/nginx/error.log',
      :http_proxy_temp_path => '/var/lib/nginx/proxy',
      :http_fastcgi_temp_path => '/var/lib/nginx/fastcgi',
      :http_client_body_temp_path => '/var/lib/nginx/body'

    make
  end

  def install
    # startup script
    (etc/'init.d').install_p(workdir/'init.d', 'nginx')

    # config files
    (etc/'nginx').install Dir['conf/*']

    # default site
    (var/'www/nginx-default').install Dir['html/*']

    # server
    sbin.install Dir['objs/nginx']

    # man page
    man8.install Dir['objs/nginx.8']
    sh 'gzip', man8/'nginx.8'

    # support dirs
    %w( run lock log/nginx lib/nginx ).map do |dir|
      (var/dir).mkpath
    end
  end
end
