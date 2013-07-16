# modules/openssl/manifests/init.pp
#
# Synopsis:
#       Configures OpenSSL on a host.
#
# Parameters:
#       Name__________  Notes_  Description___________________________
#

class openssl {

    include 'openssl::params'

    package { $openssl::params::packages:
        ensure  => installed,
    }

    file { '/etc/pki/tls/openssl.cnf':
        owner   => 'root',
        group   => 'root',
        # Must be world readable; git reads this, for example.
        mode    => '0644',
        require => Package['openssl'],
        source  => [
            'puppet:///private-host/openssl/openssl.cnf',
            'puppet:///private-domain/openssl/openssl.cnf',
            'puppet:///modules/openssl/openssl.cnf',
        ],
    }

    # This is needed by modules/openssl/manifests/tls-ca-certificate.pp, but
    # appears here to prevent duplicate declarations.  Plus it only need be
    # run once for all CA certificates installed.
    exec { 'update-ca-trust':
        refreshonly => true,
    }

}
