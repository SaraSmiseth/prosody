# Changelog

## Unreleased

* Nothing

## v1.2.0

### New features

* New environment variables for database settings. It is now possible to use MariaDB or Postgres instead of SQLite. SQLite is the default. See [README](https://github.com/SaraSmiseth/prosody#environment-variables).

### Updates

* Updated luarocks to version 3.7.0.

## v1.1.4

### Updates

* Updated to Prosody version [0.11.8](https://blog.prosody.im/prosody-0.11.8-released/).
* Updated luarocks to version 3.5.0.

## v1.1.3

### New features

* Set pidfile in prosody.cfg.lua.
* Created a tests folder which contains pytest and bats tests.

### Bug fixes

* Fixed using list ENV variables with multiple values.

## v1.1.2

### Updates

* Updated to Prosody version [0.11.7](https://blog.prosody.im/prosody-0.11.7-released/).
* Updated luarocks to version 3.4.0.

### New features

* Made 04-server_contact_info.cfg.lua configurable with ENV variables. Fixes [#4](https://github.com/SaraSmiseth/prosody/issues/4).
* Made 03-e2e-policy.cfg.lua configurable with ENV variables. Fixes [#9](https://github.com/SaraSmiseth/prosody/issues/9).
* Added E2E_POLICY_WHITELIST ENV variable to configure e2e_policy_whitelist. Fixes [#10](https://github.com/SaraSmiseth/prosody/issues/10).

### Bug fixes

* Cherry picked [commit](https://github.com/zipizap/prosody/commit/fa13a990a1b87745ae5f5fe8297cb0669f9e8779) from [zipizap/prosody](https://github.com/zipizap/prosody) which fixes a bug with env-vars not beeing initialized.

### Other changes

* Changed hashing of downloaded packages in Dockerfile to sha256.

## v1.1.1

* Updated to Prosody version [0.11.6](https://blog.prosody.im/prosody-0.11.6-released/).
* Replace "master" with "dev".

## v1.1.0

### New features

* Enable "announce" and "lastactivity" modules.
* Add PROSODY_ADMINS to specify who is an administrator. Fixes #7

### Breaking changes

* Move global ssl section to https_ssl and legacy_ssl_ssl section. It is only needed there. #3
  * <https://prosody.im/doc/ports#ssl_configuration>

As explained in the [README](https://github.com/SaraSmiseth/prosody#ssl-certificates) this setup uses automatic location to find your certs. This did not work correctly before this change. It just always used the main certificate defined with the global `ssl` config setting. This setting was removed and for the [services](https://prosody.im/doc/certificates#service_certificates) that do not use automatic location new global settings were introduced. These are `legacy_ssl_ssl` and `https_ssl`.

### Other changes

* Add badges to README. Fixes #5.
* Add link to official documentation on certificate permissions to README. Related to #3

## v1.0.0

* First version
