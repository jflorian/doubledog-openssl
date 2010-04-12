# /etc/puppet/modules/openssl/manifests/classes/openssl.pp

class openssl {

    package { "openssl":
	ensure	=> installed,
    }

    file { "/etc/pki/tls/openssl.cnf":
        group	=> "root",
        mode    => 640,
        owner   => "root",
        require => Package["openssl"],
        source  => "puppet:///modules/openssl/openssl.cnf",
    }

}
