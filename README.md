<!--
# This file is part of the doubledog-openssl Puppet module.
# Copyright 2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later
-->

# openssl

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with openssl](#setup)
    * [What openssl affects](#what-openssl-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with openssl](#beginning-with-openssl)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module lets you manage OpenSSL, primarily deployment of x509 certificates and certificate authorities.

## Setup

### What openssl Affects

### Setup Requirements

### Beginning with openssl

## Usage

## Reference

**Classes:**

* [openssl](#openssl-class)

**Defined types:**

* [openssl::tls\_ca\_certificate](#openssltls\_ca\_certificate-defined-type)
* [openssl::tls\_certificate](#openssltls\_certificate-defined-type)


### Classes

#### openssl class

This class manages the basic OpenSSL installation.  It is generally not necessary to include this class directly, unless you want OpenSSL installed but don't plan to manage any certificates with this module.

##### `packages`
An array of package names needed for the OpenSSL installation.  The default should be correct for supported platforms.


### Defined types

#### openssl::tls\_ca\_certificate defined type

This defined type manages a TLS CA certificate file.

##### `namevar` (required)
An arbitrary identifier for the TLS CA certificate instance unless the *cert_name* parameter is not set in which case this must provide the value normally set with the *cert_name* parameter.

##### `cert_content`
Literal content for the TLS CA certificate file.  If neither *cert_content* nor *cert_source* is given, the content of the file will be left unmanaged.

##### `cert_name`
Name to be given to the TLS CA certificate file, without any path details or file suffixes (e.g., `'.crt'`).  This may be used in place of *namevar* if it's beneficial to give *namevar* an arbitrary value.

##### `cert_source`
URI of the TLS CA certificate file content.  See *cert_content* for other important details.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean value may also be used with `true` equivalent to `present` and `false` equivalent to `absent`.


#### openssl::tls\_certificate defined type

This defined type manages a TLS certificate and private key file pair.

##### `namevar` (required)
An arbitrary identifier for the TLS certificate/key pair instance unless the *cert_name* parameter is not set in which case this must provide the value normally set with the *cert_name* parameter.

##### `cert_content`
Literal content for the TLS certificate file.  If neither *cert_content* nor *cert_source* is given, the content of the file will be left unmanaged.

##### `cert_name`
The base name to be given to the TLS certificate and private key file pair, without any path details or file suffixes (e.g., `'.crt'`, `'.key'`).  This may be used in place of *namevar* if it's beneficial to give *namevar* an arbitrary value.  If given, this equally affects the private key file.

##### `cert_path`
File system path to where the certificate file is to be deployed.  Defaults to `'/etc/pki/tls/certs'`.

##### `cert_source`
URI of the TLS certificate file content.  See *cert_content* for other important details.

##### `cert_suffix`
The suffix to be given to the TLS certificate file.  Defaults to `'.crt'`.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean value may also be used with `true` equivalent to `present` and `false` equivalent to `absent`.

##### `group`
Group that is to own the certificate and key files.  Defaults to `'root'`.

##### `key_content`
Literal content for the TLS private key file.  One of *key_content* or *key_source* must be given if the private key file is to exist.  If neither are set, any existing file will be removed.

##### `key_path`
File system path to where the private key file is to be deployed.  Defaults to `'/etc/pki/tls/private'`.

##### `key_source`
URI of the TLS private key file content.  See *key_content* for other important details.

##### `owner`
User that is to own the certificate and key files.  Defaults to `'root'`.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

This should be compatible with Puppet 3.x and is being used with Puppet 4.x as well.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
