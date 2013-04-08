class Nginx < DebianFormula
  homepage 'http://nginx.org/'

  name 'nginx'
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

  def build
    flags = [].push \
      '--with-http_stub_status_module',
      '--with-http_ssl_module',
      '--with-http_gzip_static_module',
      '--with-pcre',
      '--with-debug'

    self.class.modules.each do |mod|
      flags << "--add-module=#{builddir / mod}.git"
    end

    options = {}.merge \
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

    configure *flags.push(options)
    make
  end

  def self.nginx_module(repo, options = {})
    name = repo.split('/').last
    modules << name

    url = "https://github.com/#{repo}.git"

    if options[:tag]
      options = {:sha => sha_for_tag(url, options[:tag])}
    end

    source url, options
  end

  def self.modules
    @modules ||= []
  end

  def self.sha_for_tag(url, tag)
    %x(git ls-remote #{url} --tag #{tag}).split.first
  end
end
