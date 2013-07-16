# modules/openssl/manifests/params.pp
#
# Synopsis:
#       Parameters for the OpenSSL puppet module.


class openssl::params {

    case $::operatingsystem {
        Fedora: {

            $packages = [
                'openssl',
            ]

        }

        default: {
            fail ("The OpenSSL module is not yet supported on ${operatingsystem}.")
        }

    }

}
