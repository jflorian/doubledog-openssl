# modules/openssl/manifests/init.pp
#
# == Class: openssl
#
# Manages OpenSSL.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*packages*]
#   An array of package names needed for the OpenSSL installation.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2017 John Florian


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
