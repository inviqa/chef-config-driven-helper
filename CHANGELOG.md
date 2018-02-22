## 3.0.0 (21 Feb 2018)

CHANGES:

  * Remove RSA encryption and 3DES TLS ciphers as defaults

## 2.8.0 (22 Feb 2018)

NEW FEATURES:
  * #92 Ability to remove weak RSA and 3DES ciphers without fully copying the strong ones
  * Order ECDSA certificate ciphers ahead of RSA certificate ciphers

## 2.7.0 (04 Apr 2016)

NEW FEATURES:

  * #91 Add support for Nginx http_realip

## 2.6.1 (06 Oct 2016)

BUG FIXES:

  * #87 Fix issue with basic auth requiring allow_from to be set

## 2.6.0 (06 Sep 2016)

NEW FEATURES:

  * #64 Add basic auth ability to nginx, to match apache.

## 2.5.1 (25 Aug 2016)

CHANGES:

  * #84 Change capistrano definition usage to use site name rather than :deploy_to as this is more unique.

## 2.5.0 (04 Aug 2016)

CHANGES:

  * #82 Self signed ssl fixes

## 2.4.0 (03 Aug 2016)

NEW FEATURES:

  * #80 Ensure pre-existing ssl files don't get overwritten by this cookbook
  * #81 Add recipe to generate self signed ssl

## 2.3.0 (22 Jul 2016)

NEW FEATURES:

  * #62 Add ability to proxy via NGINX

BUG FIXES:

  * #79 Fix issue with un-declared packages-additional error

## 2.2.2 (20 Jul 2016)

SECURITY FIXES:

  * #78 Httpoxy fix for cookbook version 2.2

## 1.5.3 (20 Jul 2016)

SECURITY FIXES:

  * #79 Httpoxy fix for cookbook version 1.5

## 2.2.1 (13 Jul 2016)

BUG FIXES:

  * #75 Reverse <Directory /> deny in Httpd 2.4 if no restrictions
  * #77 Fix issue with apache2 cookbook < 2 apache_site enable

## 2.2.0 (06 Jul 2016)

NEW FEATURES:

  * #76 Add packages-additional recipe to replace package recipe for Chef 12.9+

CHANGES:

  * #76 Provide more detailed error information when packages recipe can't be used

## 2.1.0 (28 Jun 2016)

NEW FEATURES:

  * Apache 2.4 compatibility in the apache virtual host. Comprising of:
    * #66 - Fix name of vhost template resource so the apache2 cookbook can enable the vhost
    * #68 - Fix incompatible vhost configuration so that it works under apache 2.2 and 2.4
  * #73 - Support for http digest auth in apache_site and more attributes

BUG FIXES:

    * #67 - Ubuntu compatibility for logs directory location
    * #72 - Fix issues with combinations of apache_site allow_from and basic_username

## 2.0.3 (23 May 2016)

BUG FIXES:

  * #60 Delete any allowed_incoming_ports marked false

## 2.0.2 (06 May 2016)

IMPROVEMENTS:

  * Pin build-essential cookbook to ~> 1.4 to speed up dependency resolution

## 2.0.1 (06 May 2016)

BUG FIXES:

  * #59 Pin database cookbook to 2.0.x to fix mysql-* recipes

## 2.0.0 (04 May 2016)

IMPROVEMENTS:

  * #56 Loosen cookbook constraints to support httpd 2.4

CHANGES:

  * #57 Disable nginx https variable emulation by default
  * #58 Fork off deploy user work from capistrano recipe to new cookbook

## 1.5.0 (10 November 2015)

IMPROVEMENTS:

  * Add locations configuration to replace static_dirs and restricted_dirs
  * Separate includes into includes_first and include_last for greater control

## 1.4.3 (8 September 2015)

IMPROVEMENTS:

  * Fix specs/tests
  * Add Chef 12 compatibility for nginx-sites/apache-sites

BUG FIXES:

  * Remove obsolete chef-solo-search and users dependencies

## 1.4.2 (9 August 2015)

BUG FIXES:

  * Retag due to 1.4.1 missing metadata version update

## 1.4.1 (9 July 2015)

BUG FIXES:

  * Fix issue with custom user databag name not working

## 1.4.0 (3 July 2015)

IMPROVEMENTS:

  * Add support for encrypted user databags on chef-solo
