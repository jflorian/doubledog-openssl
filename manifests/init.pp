# modules/openssl/manifests/init.pp

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

}
