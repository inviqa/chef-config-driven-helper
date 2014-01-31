name              "apache-sites"
maintainer        "Inviqa"
maintainer_email  "msimons@inviqa.com"
license           "Apache 2.0"
description       "Propagates sites from node config to web_app"
version           "1.0.0"

depends "apache2"

%w{ debian ubuntu centos redhat fedora scientific amazon windows }.each do |os|
  supports os
end

recipe "apache-sites", "Propagates sites from node config to web_app"