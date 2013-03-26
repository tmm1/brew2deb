require './formula'

class NginxDevelopment < Nginx
  url 'http://nginx.org/download/nginx-1.3.15.tar.gz'
  md5 'ded252047393c79a31b0862e9166a065'
  version '1.3.15+github1'

  nginx_module 'nickh/chunkin-nginx-module', :sha => '225fcbc'
  nginx_module 'agentzh/headers-more-nginx-module', :tag => 'v0.19'
  nginx_module 'vkholodkov/nginx-upload-module', :sha => '2ec4e4fb' #0.2.0
  nginx_module 'yaoweibin/nginx_syslog_patch', :sha => 'b2198a2a' #v0.25

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => [
       'https://github.com/nickh/nginx/commit/2e05240b8d043125379a68957c6d6c657c48bb0a.patch',
       workdir/'src/nginx_syslog_patch.git/syslog_1.3.14.patch',
       'nginx-name-leak.patch',
     ]}
  end
end

