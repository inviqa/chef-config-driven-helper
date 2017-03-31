Config driven helper cookbook
===============================

Usage
-----

The config driven helper cookbook is a simple catchall cookbook designed to drive other cookbooks that are not normally config driven.

Enabling this ability means that there is less duplication and therefore less scope for error across projects which utilize this cookbook.

### Apache sites
The apache sites helper enables you to create an apache vhost simply by defining it as node attributes.

Add `config-driven-helper::apache-sites` to enable it.

Here is a simple example:

```json
{
  "apache": {
    "sites": {
      "inviqa": {
        "server_name": "inviqa.com",
        "docroot": "/var/www/inviqa.com"
      }
    }
  }
}
```

The above, when integrated in to your chef attributes will create a vhost called `inviqa` that responds to the vhost `inviqa.com` and has a document root of `/var/www/inviqa.com`.

Internally the contents of the 'inviqa' site attribute will be proxied to the apache2 cookbook `web_app` resource. This means that any configuration that is valid for `web_app` is valid here too!

As an example, consider changing the template to a custom one that you have created in a project cookbook called project.

```json
{
  "apache": {
    "sites": {
      "inviqa": {
        "server_name": "inviqa.com",
        "docroot": "/var/www/inviqa.com",
        "template": "my-custom-template.conf.erb",
        "cookbook": "my-project-cookbook"
      }
    }
  }
}

```

We recommend that you use an abstract name for the key of the site (and not the hostname). This is to allow you to share site attributes across environments with minimal duplication.

#### SSL

The apache sites helper also provides a means to create https vhosts. To do this you must set the 'protocols' array.

```json
{
  "apache": {
    "sites": {
      "inviqa": {
        "server_name": "inviqa.com",
        "docroot": "/var/www/inviqa.com",
        "protocols": [ "http", "https" ]
      }
    }
  }
}

```

This example will create two vhosts; `inviqa` and `inviqa.ssl`. `inviqa.ssl` will be configured to respond on port 443 with some sensible SSL default settings (including limiting to secure protocols and ciphersuites).

The defaults for a site are defined here: https://github.com/inviqa/chef-config-driven-helper/blob/master/attributes/default.rb#L14

These default will be merged in to any given site.

Therefore, by default the SSL vhost template will use `/etc/pki/tls/certs/cert.pem` as the certfile and `/etc/pki/tls/private/key.pem` as the keyfile.

The apache sites helper will populate these keys for you by looking at the `node['ssl_certs']['/etc/pki/tls/certs/cert.pem']` and `node['ssl_certs']['/etc/pki/tls/private/key.pem']` attributes.

You can override any of these values by simply defining them in your site attributes. For a (contrived) example, to change the keyfile path:

```json
{
  "apache": {
    "sites": {
      "inviqa": {
        "server_name": "inviqa.com",
        "docroot": "/var/www/inviqa.com",
        "protocols": [ "http", "https" ],
        "keyfile": "/tmp/my-super-insecure-keyfile.pem"
      }
    }
  }
}

```

It is assumed that projects that use this cookbook also use the data-bag-merge cookbook from https://cookbooks.opscode.com/cookbooks/data-bag-merge. This cookbook merges encrypted data bags in to your chef attributes to enabled encrypted attributes for cookbooks that do not directly support them.

#### Server params

To add fastcgi_param for Nginx or SetEnv for Apache use php_server_variables under sites key, like in this example for apache (it's similiar for nginx):

```json
{
  "apache": {
    "sites": {
      "inviqa": {
        "server_name": "inviqa.com",
        "docroot": "/var/www/inviqa.com",
        "protocols": [ "http", "https" ],
        "php_server_variables": {
          "FOO": "bar",
          "ANOTHER": "value"
        }
      }
    }
  }
}
```

#### Capistrano

The apache sites helper also additionally set up Capistrano application targets,
configuring the folder structure and permissions of shared folders

```json
{
  "apache": {
    "sites": {
      "inviqa": {
        "capistrano": {
          "deploy_to": "/var/www/sites/inviqa.com",
          "owner": "deploy",
          "group": "deploy",
          "shared_folders": {
            "readable": {
              "folders": [
                "app"
              ]
            },
            "writeable": {
              "owner": "apache",
              "group": "apache",
              "folders": [
                "uploads",
                "app/./cache/disk"
              ]
            }
          }
        }
      }
    }
  }
}
```

A shared_folders folder containing a '.' will apply permissions recursively
from the dot onwards, and not preceding directory names. A shared_folder section
that doesn't have owner or group will inherit the top-level owner and group.

This creates the following folder structure:

```
deploy deploy /var/www/sites/inviqa.com
deploy deploy /var/www/sites/inviqa.com/releases
deploy deploy /var/www/sites/inviqa.com/shared
deploy deploy /var/www/sites/inviqa.com/shared/app
apache apache /var/www/sites/inviqa.com/shared/app/cache
apache apache /var/www/sites/inviqa.com/shared/app/cache/disk
apache apache /var/www/sites/inviqa.com/shared/uploads
```

### Nginx sites

The nginx sites helper is very similar to the apache sites helper with the exception that it does not proxy to any kind of `web_app` helper and uses the `nginx` top level attribute instead.

Add `config-driven-helper::nginx-sites` to enable it.

```json
{
  "nginx": {
    "sites": {
      "inviqa": {
        "server_name": "inviqa.com",
        "docroot": "/var/www/inviqa.com",
        "protocols": [ "http", "https" ],
        "keyfile": "/tmp/my-super-insecure-keyfile.pem"
      }
    }
  }
}

```

#### http_realip
eable nginx_http_realip module to be used in conjunction with HTTP_AUTH
to be able to match the real ip of a visitor even if it comes
from a Proxied connection (i.e. Varis, CloudFlare, others)

It can be used togheter with Inviqa's cookbook [cloudflare-ips](https://github.com/inviqa/chef-cloudflare-ips)

Default values:
```
default['nginx']['real_ip_header'] = "X-Forwarded-For"
default['nginx']['real_ip_from'] = []
default['nginx']['real_ip_recursive'] = "on"
```

Add `config-driven-helper::nginx-http-realip` to enable it.
```json
{
  "nginx": {
    "real_ip_from": [
      "1.2.3.4",
      "5.6.7.8"
    ]
  }
}

```

### Mysql users

The mysql users helper enables you to create mysql users from attributes. It proxies the attributes to the `mysql_database_user` resource defined by the `database` cookbook here: https://github.com/opscode-cookbooks/database#database_user. This means that any attributes valid there are valid here.

Add `config-driven-helper::mysql-users` to enable it.

The following example creates the user `my_username` with the defined password and with `GRANT ALL PRIVELEGES` applied to `database-to-grant`.

```json
{
  "mysql": {
    "users": {
      "my_username": {
        "password": "my-password-from-data-bag-merge",
        "database_name": "database-to-grant"
      }
    }
  }
}
```

### Firewall

The iptables-standard recipe defines a standard ipv4 + ipv6 firewall, allowing
all loopback/imcp traffic, listening incoming port traffic for services
accessible externally, and related/established traffic for TCP traffic after
connections are established.

By default, it will allow only http, https and ssh traffic, however you can
override this by defining more ports in attributes.

```json
{
  "iptables-standard": {
    "allowed_incoming_ports": {
      "rsync": "rsync",
      "non-standard-software": "12345"
    }
  }
}
```

The ports for each item in the array are internally mapped by iptables to those
defined in /etc/services if not port numbers.

If you want to remap the port numbers of existing ports, you can do so via:

```json
{
  "iptables-standard": {
    "allowed_incoming_ports": {"http": "8080", "https": false}
  }
}
```

This will create a firewall with http port 8080, along with the default ssh port
as inherited from the cookbook attributes, leaving the https port blocked.

### Mysql databases

The mysql database helper enables you to create mysql databases from attributes. It proxies the attributes to the `mysql_database` resource defined by the `database` cookbook here: https://github.com/opscode-cookbooks/database#database. This means that any attributes valid there are valid here.

Add `config-driven-helper::mysql-databases` to enable it.

The following example creates the database `my_database` with no additional options.

```json
{
  "mysql": {
    "databases": {
      "my_database": { }
    }
  }
}
```

### Additional Packages

The packages helper simply enables you to define a list of packages to install. Due to the way that chef merges array attributes you should take care to define all packages at the same precedence level. We may in the future support hash lists to enable purges too.

Add `config-driven-helper::packages-additional` to enable it.

The following example installs both git and java packages.

```json
{
  "packages-additional": {
    "git": "install",
    "java": "install"
  }
}
```

### Services

The services helper enables you to perform simple actions on pre-defined services such as start / stop / enable / disable them. Note that the service name should be name used by chef, not that of the underlying OS (though they are often the same).

Add `config-driven-helper::services` to enable it.

The following example shows how to make sure that the mysql service is both enabled and started.

```json
  "services": {
    "mysql": [ "enable", "start" ]
  }
```

### Mysql ruby

This recipe is primarily for internal use by the mysql helpers. It forces the install of the `mysql` gem in to the chef ruby. This is provided because `chef_gem` is not an appropriate solution where mysql is installed in the same run and depends on a different version of `mysql-libs` (or your OS equivalent) to the version of MySQL being installed. A simple example of this is installing Percona on CentOS 6.5.

Add `config-driven-helper::mysql-ruby` to enable it (although it is explicitly included by the mysql helpers so this should only be necessary if used standalone).

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

Supermarket share
-----------------

[stove](http://sethvargo.github.io/stove/) is used to create git tags and
publish the cookbook on supermarket.chef.io.

To tag/publish you need to be a contributor to the cookbook on Supermarket and
run:

```
$ stove login --username <your username> --key ~/.chef/<your username>.pem
$ rake publish
```

It will take the version defined in metadata.rb, create a tag, and push the
cookbook to http://supermarket.chef.io/cookbooks/config-driven-helper


License and Authors
-------------------
- Author:: Mike Simons
- Author:: Andy Thompson
- Author:: Kieran Evans

```text
Copyright:: 2014-2015 The Inviqa Group Ltd

See LICENSE file
```
