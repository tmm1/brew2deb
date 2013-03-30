require './base'

class NginxLegacy < Nginx
  url 'http://nginx.org/download/nginx-1.0.13.tar.gz'
  md5 '58360774e4875e8fc4c4286448cb54d0'
  version '1.0.13+github6'

  nginx_module 'nickh/chunkin-nginx-module', :sha => '140d61c3'
  nginx_module 'agentzh/headers-more-nginx-module', :tag => '137855d'
  nginx_module 'vkholodkov/nginx-upload-module', :sha => '4a9d8b5353'
  nginx_module 'yaoweibin/nginx_syslog_patch', :sha => 'afeea6d'

  def patches
    {:p0 => 'request_start_variable.patch',
     :p1 => [
       'nginx-header-leak-final.patch',
       'https://github.com/nickh/nginx/commit/2e05240b8d043125379a68957c6d6c657c48bb0a.patch',
       workdir/'src/nginx_syslog_patch.git/syslog_1.0.6.patch',
       'nginx-disable-ssl-compression.patch',
       'nginx-name-leak.patch',
       'nginx-msec-backport.patch',
     ]}
  end
end
