# modules/openssl/manifests/tls_certificate.pp
#
# == Define: openssl::tls_ca_certificate
#
# Manages a TLS certificate and private key file pair for OpenSSL.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the TLS certificate/key pair instance unless
#   the "cert_name" parameter is not set in which case this must provide the
#   value normally set with the "cert_name" parameter.
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*cert_name*]
#   The base name to be given to the TLS certificate and private key file
#   pair, without any path details or file euffixes (e.g., ".crt", ".key",
#   etc.).  This may be used in place of "namevar" if it's beneficial to give
#   namevar an arbitrary value.  If given, this equally affects the private
#   key file.
#
# [*cert_content*]
#   Literal content for the TLS certificate file.  If neither "cert_content"
#   nor "cert_source" is given, the content of the file will be left
#   unmanaged.
#
# [*cert_source*]
#   URI of the TLS certificate file content.  See "cert_content" for other
#   important details.
#
# [*key_content*]
#   Literal content for the TLS private key file.  One of "key_content"
#   or "key_source" must be given if the private key file is to exist.  If
#   neither are set, any existing file will be removed.
#
# [*key_source*]
#   URI of the TLS private key file content.  See "key_content" for other
#   important details.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2016 John Florian


define openssl::tls_certificate (
        $ensure='present',
        $owner='root',
        $group='root',
        $cert_name=$title,
        $cert_content=undef,
        $cert_source=undef,
        $key_content=undef,
        $key_source=undef,
    ) {

    include '::openssl::params'

    file { "/etc/pki/tls/certs/${cert_name}.crt":
        ensure    => $ensure,
        owner     => $owner,
        group     => $group,
        mode      => '0444',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'cert_t',
        subscribe => Package[$::openssl::params::packages],
        content   => $cert_content,
        source    => $cert_source,
    }

    if $key_content != undef or $key_source != undef {
        file { "/etc/pki/tls/private/${name}.key":
            ensure    => $ensure,
            owner     => $owner,
            group     => $group,
            mode      => '0400',
            seluser   => 'system_u',
            selrole   => 'object_r',
            seltype   => 'cert_t',
            subscribe => Package[$::openssl::params::packages],
            content   => $key_content,
            source    => $key_source,
        }
    } else {
        file { "/etc/pki/tls/private/${name}.key":
            ensure    => absent,
        }
    }

}
