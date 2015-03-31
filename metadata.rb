name              "config-driven-helper"
maintainer        "Inviqa"
maintainer_email  "msimons@inviqa.com"
license           "Apache 2.0"
description       "enable driving cookbooks that are not normally config driven to be so"
version           "1.3.4"

depends "apache2", "~> 1.8"
depends 'iptables-ng', '~> 2.2.0'
depends "mysql", "~> 4.0"
depends 'nginx', '< 2.5'
depends 'chef-solo-search', '~> 0.5.1'
depends "database", "~> 2.0"
depends "build-essential", "~> 1.4"
depends 'ssh_known_hosts', '~> 2.0'
depends "users", "~> 1.7"

%w{ debian ubuntu centos redhat fedora scientific amazon windows }.each do |os|
  supports os
end

recipe "apache-sites", "Propagates sites from node config to web_app"
recipe "nginx-sites", "Propagates sites from node config to nginx site"
recipe "mysql-users", "Creates mysql users using the database cookbook"
recipe "mysql-ruby", "Installs MySQL ruby gem in chef ruby"
recipe "mysql-databases", "Creates mysql databases using the database cookbook"
recipe "packages", "Installs packages"
recipe "services", "Enables service actions"
