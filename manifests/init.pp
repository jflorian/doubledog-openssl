# modules/openssl/manifests/init.pp
#
# == Class: openssl
#
# Manages OpenSSL on a host.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2016 John Florian


class openssl (
    ) inherits ::openssl::params {


    package { $openssl::params::packages:
        ensure  => installed,
    }

    # This is needed by Define[openssl::tls_ca_certificate], but appears here
    # to prevent duplicate declarations.  Plus it only need be run once for
    # all CA certificates installed.
    exec { 'update-ca-trust':
        refreshonly => true,
    }

}
