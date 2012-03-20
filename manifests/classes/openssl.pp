# modules/openssl/manifests/classes/openssl.pp

class openssl {

    package { 'openssl':
	ensure	=> installed,
    }

    file { '/etc/pki/tls/openssl.cnf':
        group	=> 'root',
        # Must be world readable; git reads this, for example.
        mode    => '0644',
        owner   => 'root',
        require => Package['openssl'],
        source  => [
            'puppet:///private-host/openssl/openssl.cnf',
            'puppet:///private-domain/openssl/openssl.cnf',
            'puppet:///modules/openssl/openssl.cnf',
        ],
    }

}
