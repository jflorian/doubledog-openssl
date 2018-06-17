#
# == Class: openssl
#
# Manages OpenSSL.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-openssl Puppet module.
# Copyright 2010-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class openssl (
        Array[String]           $packages,
    ) {

    package { $packages:
        ensure => installed,
    }

    # This is needed by Define[openssl::tls_ca_certificate], but appears here
    # to prevent duplicate declarations.  Furthermore, it need only be run
    # once for all CA certificates installed.
    exec { 'update-ca-trust':
        refreshonly => true,
    }

}
