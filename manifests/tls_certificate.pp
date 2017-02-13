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
#   Instance is to be 'present' (default) or 'absent'.  Alternatively,
#   a Boolean value may also be used with true equivalent to 'present' and
#   false equivalent to 'absent'.
#
# [*cert_content*]
#   Literal content for the TLS certificate file.  If neither "cert_content"
#   nor "cert_source" is given, the content of the file will be left
#   unmanaged.
#
# [*cert_name*]
#   The base name to be given to the TLS certificate and private key file
#   pair, without any path details or file suffixes (e.g., ".crt", ".key",
#   etc.).  This may be used in place of "namevar" if it's beneficial to give
#   namevar an arbitrary value.  If given, this equally affects the private
#   key file.
#
# [*cert_path*]
#   File system path to where the certificate file is to be deployed.
#   Defaults to '/etc/pki/tls/certs'.
#
# [*cert_source*]
#   URI of the TLS certificate file content.  See "cert_content" for other
#   important details.
#
# [*group*]
#   Group that is to own the certificate and key files.  Defaults to 'root'.
#
# [*key_content*]
#   Literal content for the TLS private key file.  One of "key_content"
#   or "key_source" must be given if the private key file is to exist.  If
#   neither are set, any existing file will be removed.
#
# [*key_path*]
#   File system path to where the private key file is to be deployed.
#   Defaults to '/etc/pki/tls/private'.
#
# [*key_source*]
#   URI of the TLS private key file content.  See "key_content" for other
#   important details.
#
# [*owner*]
#   User that is to own the certificate and key files.  Defaults to 'root'.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2017 John Florian


define openssl::tls_certificate (
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        Optional[String[1]]     $cert_content=undef,
        String[1]               $cert_name=$title,
        String[1]               $cert_path='/etc/pki/tls/certs',
        Optional[String[1]]     $cert_source=undef,
        String[1]               $group='root',
        Optional[String[1]]     $key_content=undef,
        String[1]               $key_path='/etc/pki/tls/private',
        Optional[String[1]]     $key_source=undef,
        String[1]               $owner='root',
    ) {

    include '::openssl'

    file { "${cert_path}/${cert_name}.crt":
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
        file { "${key_path}/${name}.key":
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
        file { "${key_path}/${name}.key":
            ensure => absent,
        }
    }

}
