name              "config-driven-helper"
maintainer        "Inviqa"
maintainer_email  "msimons@inviqa.com"
license           "Apache 2.0"
description       "enable driving cookbooks that are not normally config driven to be so"
version           "1.0.1"

depends "apache2"
depends "database"

%w{ debian ubuntu centos redhat fedora scientific amazon windows }.each do |os|
  supports os
end

recipe "apache-sites", "Propagates sites from node config to web_app"
recipe "nginx-sites", "Propagates sites from node config to nginx site"
recipe "mysql-users", "Creates mysql users using the database cookbook"
recipe "mysql-databases", "Creates mysql databases using the database cookbook"
