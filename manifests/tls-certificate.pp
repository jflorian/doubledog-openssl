# modules/openssl/manifests/tls-certificate.pp
#
# Synopsis:
#       Installs a TLS certificate (key and certificate files) for OpenSSL.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#
#       name                    instance name
#
#       ensure          1       instance is to be present/absent
#
#       key_source      2       URI of private certificate key file
#
#       cert_source             URI of public certificate file
#
# Notes:
#
#       1. Default is 'present'.
#
#       2. Default is '', which indicates that the private key file is not to
#       be installed.  Useful if only the public certificate portion is to be
#       installed.
#
# Requires:
#       Class['openssl']


define openssl::tls-certificate ($ensure='present',
                                 $owner='root', $group='root',
                                 $key_source='', $cert_source) {

    if $key_source != '' {
        file { "/etc/pki/tls/private/${name}.key":
            ensure  => $ensure,
            group   => $group,
            mode    => '0400',
            owner   => $owner,
            require => Package['openssl'],
            selrole => 'object_r',
            seltype => 'cert_t',
            seluser => 'system_u',
            source  => $key_source,
        }
    }

    file { "/etc/pki/tls/certs/${name}.crt":
        ensure  => $ensure,
        group   => $group,
        mode    => '0444',
        owner   => $owner,
        require => Package['openssl'],
        selrole => 'object_r',
        seltype => 'cert_t',
        seluser => 'system_u',
        source  => $cert_source,
    }

}
