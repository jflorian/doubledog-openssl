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
#   Instance is to be 'present' (default) or 'absent'.  Alternatively,
#   a Boolean value may also be used with true equivalent to 'present' and
#   false equivalent to 'absent'.
#
# [*cert_content*]
#   Literal content for the TLS CA certificate file.  If neither
#   "cert_content" nor "cert_source" is given, the content of the file will be
#   left unmanaged.
#
# [*cert_name*]
#   Name to be given to the TLS CA certificate file, without any path details
#   or file euffixes (e.g., ".crt").  This may be used in place of "namevar"
#   if it's beneficial to give namevar an arbitrary value.
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
# Copyright 2010-2017 John Florian


define openssl::tls_ca_certificate (
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
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
