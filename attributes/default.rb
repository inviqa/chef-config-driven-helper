default['nginx-sites']['secure_port'] = 443
default['nginx-sites']['insecure_port'] = 80
default['nginx-sites']['endpoint'] = 'index.php'
default['nginx-sites']['php_support'] = true
default['nginx-sites']['php-fpm'] = {
  'host' => '127.0.0.1',
  'port' => 9000,
  'socket' => '/var/run/php-fpm-www.sock',
  'listen' => 'socket'
}
default['nginx-sites']['ssl'] = {
  'certfile' => '/etc/ssl/cert.pem',
  'keyfile' => '/etc/ssl/key.pem',
  'protocols' => 'TLSv1 TLSv1.1 TLSv1.2',
  'ciphersuite' => "ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;"
}
default['nginx-sites']['template'] = 'nginx_site.conf.erb'
default['nginx-sites']['cookbook'] = 'config-driven-helper'
default['nginx-sites']['protocols'] = ['http']

# Use deep-merge to do a deep-copy
default['apache-sites'] = default['nginx-sites'].clone
default['apache-sites']['template'] = 'apache_site.conf.erb'
default['apache-sites']['cookbook'] = 'config-driven-helper'
default['apache-sites']['server_aliases'] = []
default['apache-sites']['ssl']['cacertfile'] = nil
default['apache-sites']['ssl']['certchainfile'] = nil
default['apache-sites']['ssl']['protocols'] = "All -SSLv2 -SSLv3" # TLS1, 1.1 & 1.2 compatible even if OpenSSL < 1.0.1

default['mysql']['connections']['default'] = {
  :username => "root",
  :password => node["mysql"]["server_root_password"],
  :host => "localhost"
}
