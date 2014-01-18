# modules/openssl/manifests/tls-ca-certificate.pp
#
# Synopsis:
#       Installs a TLS Certificate Authority certificate for OpenSSL.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#
#       name                    instance name
#
#       ensure          1       instance is to be present/absent
#
#       cert_source             URI of public certificate file
#
# Notes:
#
#       1. Default is 'present'.
#
# Requires:
#       Class['openssl']


define openssl::tls_ca_certificate (
    $ensure='present',
    $owner='root', $group='root',
    $key_source='', $cert_source
    ) {

    if $operatingsystemrelease < 19 {
        # The certificate portion gets installed just like any other certificate.
        openssl::tls_certificate { "${name}":
            cert_source => "${cert_source}",
        }
    } else {

        file { "/etc/pki/ca-trust/source/anchors/${name}.crt":
            ensure  => $ensure,
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            source  => "${cert_source}",
            notify  => Exec['update-ca-trust'],
        }

        # Establish a link to our traditional location since many other
        # services (e.g., openldap, sssd) expect it there.
        #
        # TODO: Abolish this once all hosts are Fedora >= 19 and all
        # references to this location are actually using the above.
        file { "/etc/pki/tls/certs/${name}.crt":
            ensure  => link,
            target  => "/etc/pki/ca-trust/source/anchors/${name}.crt",
        }
    }

}
