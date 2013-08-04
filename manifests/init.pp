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

    # This is needed by modules/openssl/manifests/tls-ca-certificate.pp, but
    # appears here to prevent duplicate declarations.  Plus it only need be
    # run once for all CA certificates installed.
    exec { 'update-ca-trust':
        refreshonly => true,
    }

}
