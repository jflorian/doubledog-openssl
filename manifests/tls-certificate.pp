# modules/openssl/manifests/tls-certificate.pp
#
# Synopsis:
#       Installs a TLS certificate (key and certificate files) for openssl.
#
# Parameters:
#       Name__________  Default_______  Description___________________________
#
#       name                            instance name
#       ensure          present         instance is to be present/absent
#       key_source      ''              URI of private certificate key file
#       cert_source                     URI of public certificate file
#
# Requires:
#       Class['openssl']
#
# Example usage:
#
#       include openssl
#
#       openssl::tls-certificate { 'domain-smtp':
#           key_source      => 'puppet:///private/domain-smtp.key',
#           cert_source     => 'puppet:///private/domain-smtp.crt',
#           notify          => Service['smtpd'],
#       }


define openssl::tls-certificate ($ensure='present',
                                 $owner='root', $group='root',
                                 $key_source='', $cert_source) {

    if $key_source != '' {
        file { "/etc/pki/tls/private/${name}.key":
            ensure      => $ensure,
            group       => $group,
            mode        => '0600',
            owner       => $owner,
            require     => Package['openssl'],
            selrole     => 'object_r',
            seltype     => 'cert_t',
            seluser     => 'system_u',
            source      => $key_source,
        }
    }

    file { "/etc/pki/tls/certs/${name}.crt":
        ensure          => $ensure,
        group           => $group,
        mode            => '0644',
        owner           => $owner,
        require         => Package['openssl'],
        selrole         => 'object_r',
        seltype         => 'cert_t',
        seluser         => 'system_u',
        source          => $cert_source,
    }

}
