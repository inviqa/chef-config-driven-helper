name              "config-driven-helper"
maintainer        "Inviqa"
maintainer_email  "msimons@inviqa.com"
license           "Apache 2.0"
description       "enable driving cookbooks that are not normally config driven to be so"
version           "1.3.1"

depends "apache2"
depends "mysql"
depends "database"
depends "build-essential"

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
