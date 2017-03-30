## 2.0, release 2017-03-28
* updated to explicitly use digital ocean for `niso setup` and `niso teardown`
* added `droplet_kit`
* removed `digital_ocean`

## 1.5, release 2013-09-27
* `niso deploy [linode|digital_ocean] [name]` will deploy to the instance with additional attributes.

## 1.4, release 2013-09-27
* `niso teardown` no longer requires instance names as an argument, it lets you choose from a list instead.

## Past Releases
* v1.3: SSH config support. Thanks to @toooooooby
* v1.2: Evaluate everything as ERB templates by default. Added "files" folder.
* v1.1: "set -e" by default. apt-get everywhere in place of aptitude. Linode DNS support for DigitalOcean instances.
* v1.0: System functions are refactored into niso.mute() and niso.install().
* v0.9: Support for [DigitalOcean](https://www.digitalocean.com) setup / teardown.
* v0.8: Added `--sudo` option to `niso deploy`.
* v0.7: Added `erase_remote_folder` and `cache_remote_recipes` preferences for customized behavior.
* v0.6: System function niso::silencer() added for succinct log messages.
* v0.5: Role-based configuration supported. Reworked directory structure. **Incompatible with previous versions**.
