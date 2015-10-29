# modules/openssl/manifests/tls_ca_certificate.pp
#
# == Define: openssl::tls_ca_certificate
#
# Manages a TLS CA certificate certificate file for OpenSSL.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the TLS CA certificate instance unless the
#   "cert_name" parameter is not set in which case this must provide the value
#   normally set with the "cert_name" parameter.
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*cert_name*]
#   This may be used in place of "namevar" if it's beneficial to give namevar
#   an arbitrary value.
#
# [*cert_content*]
#   Literal content for the TLS CA certificate file.  If neither
#   "cert_content" nor "cert_source" is given, the content of the file will be
#   left unmanaged.
#
# [*cert_source*]
#   URI of the TLS CA certificate file content.  See "cert_content" for other
#   important details.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2015 John Florian


define openssl::tls_ca_certificate (
        $ensure='present',
        $cert_name=undef,
        $cert_content=undef,
        $cert_source=undef,
    ) {

    include '::openssl::params'

    if $cert_name {
        $cert_name_ = $cert_name
    } else {
        $cert_name_ = $name
    }

    file { "/etc/pki/ca-trust/source/anchors/${cert_name_}.crt":
        ensure    => $ensure,
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'cert_t',
        notify    => Exec['update-ca-trust'],
        subscribe => Package[$::openssl::params::packages],
        content   => $cert_content,
        source    => $cert_source,
    }

    # Establish a link to the traditional location since many other services
    # (e.g., openldap, sssd) expect it there.
    $link_ensure = $ensure ? {
        'absent' => 'absent',
        default  => link,
    }
    file { "/etc/pki/tls/certs/${cert_name_}.crt":
        ensure => $link_ensure,
        target => "/etc/pki/ca-trust/source/anchors/${cert_name_}.crt",
    }

}
