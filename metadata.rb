name              "config-driven-helper"
maintainer        "Inviqa"
maintainer_email  "msimons@inviqa.com"
license           "Apache 2.0"
description       "enable driving cookbooks that are not normally config driven to be so"
version           "1.0.0"

depends "apache2"

%w{ debian ubuntu centos redhat fedora scientific amazon windows }.each do |os|
  supports os
end

recipe "apache-sites", "Propagates sites from node config to web_app"
recipe "nginx-sites", "Propagates sites from node config to nginx site"