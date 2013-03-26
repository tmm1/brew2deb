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
end
