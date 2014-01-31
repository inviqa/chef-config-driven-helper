default['nginx-sites']['secure_port'] = 443
default['nginx-sites']['insecure_port'] = 80
default['nginx-sites']['endpoint'] = 'index.php'
default['nginx-sites']['php_fpm_port'] = 9000
default['nginx-sites']['php_fpm_host'] = '127.0.0.1'
default['nginx-sites']['ssl'] = false
default['nginx-sites']['ssl_cert'] = '/etc/ssl/cert.pem'
default['nginx-sites']['ssl_key'] = '/etc/ssl/key.pem'
default['nginx-sites']['template'] = 'nginx_site.conf.erb'
default['nginx-sites']['cookbook'] = 'config-driven-helper'

default['apache-sites'] = default['nginx-sites'].dup
default['apache-sites']['template'] = 'web_app.conf.erb'
default['apache-sites']['cookbook'] = 'apache2'