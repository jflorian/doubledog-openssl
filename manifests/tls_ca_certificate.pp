#
# == Define: openssl::tls_ca_certificate
#
# Manages a TLS CA certificate certificate file for OpenSSL.
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


define openssl::tls_ca_certificate (
        Ddolib::File::Ensure    $ensure='present',
        Optional[String[1]]     $cert_content=undef,
        String[1]               $cert_name=$title,
        Optional[String[1]]     $cert_source=undef,
    ) {

    include '::openssl'

    ::openssl::tls_certificate { $cert_name:
        ensure       => $ensure,
        cert_path    => '/etc/pki/ca-trust/source/anchors',
        cert_content => $cert_content,
        cert_source  => $cert_source,
        notify       => Exec['update-ca-trust'],
    }

    # Establish a link to the traditional location since many other services
    # (e.g., openldap, sssd) expect it there.
    $link_ensure = $ensure ? {
        'absent' => 'absent',
        default  => link,
    }
    file { "/etc/pki/tls/certs/${cert_name}.crt":
        ensure => $link_ensure,
        target => "/etc/pki/ca-trust/source/anchors/${cert_name}.crt",
    }

}
