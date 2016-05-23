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
