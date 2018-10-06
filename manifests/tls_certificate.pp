#
# == Define: openssl::tls_certificate
#
# Manages a TLS certificate and private key file pair for OpenSSL.
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


define openssl::tls_certificate (
        Ddolib::File::Ensure    $ensure='present',
        Optional[String[1]]     $cert_content=undef,
        String[1]               $cert_name=$title,
        String[1]               $cert_path='/etc/pki/tls/certs',
        Optional[String[1]]     $cert_source=undef,
        Optional[String[1]]     $cert_suffix='.crt',
        String[1]               $group='root',
        Optional[String[1]]     $key_content=undef,
        String[1]               $key_path='/etc/pki/tls/private',
        Optional[String[1]]     $key_source=undef,
        Optional[String[1]]     $key_suffix='.key',
        String[1]               $owner='root',
    ) {

    include '::openssl'

    file { "${cert_path}/${cert_name}${cert_suffix}":
        ensure    => $ensure,
        owner     => $owner,
        group     => $group,
        mode      => '0444',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'cert_t',
        subscribe => Package[$::openssl::packages],
        content   => $cert_content,
        source    => $cert_source,
    }

    if $key_content != undef or $key_source != undef {
        file { "${key_path}/${name}${key_suffix}":
            ensure    => $ensure,
            owner     => $owner,
            group     => $group,
            mode      => '0400',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'cert_t',
            subscribe => Package[$::openssl::packages],
            content   => $key_content,
            source    => $key_source,
            show_diff => false,
        }
    } else {
        file { "${key_path}/${name}${key_suffix}":
            ensure => absent,
        }
    }

}
