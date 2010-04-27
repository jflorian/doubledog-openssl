/*
== Definition: openssl::tls-certificate

Installs a TLS certificate (comprised of a key file and a certificate file).

Parameters:
- *name*: the name of the certificate
- *key_source*: resource URI where the private key can be obtained
- *cert_source*: resource URI where the public certificate can be obtained

Requires:
- Class["openssl"]

Example usage:

    include openssl

    openssl::tls-certificate { "domain-smtp":
        key_source      => "puppet:///private/domain-smtp.key",
        cert_source     => "puppet:///private/domain-smtp.crt",
        notify          => Service["httpd"],
    }

*/

define openssl::tls-certificate ($ensure="present", $key_source="", $cert_source) {

    if $key_source != "" {
        file {"/etc/pki/tls/private/${name}.key":
            ensure      => $ensure,
            group       => "root",
            mode        => "0600",
            owner       => "root",
            require     => Package["openssl"],
            selrole     => "object_r",
            seltype     => "cert_t",
            seluser     => "system_u",
            source      => $key_source,
        }
    }

    file {"/etc/pki/tls/certs/${name}.crt":
        ensure          => $ensure,
        group           => "root",
        mode            => "0644",
        owner           => "root",
        require         => Package["openssl"],
        selrole         => "object_r",
        seltype         => "cert_t",
        seluser         => "system_u",
        source          => $cert_source,
    }

}

