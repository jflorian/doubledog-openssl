# modules/openssl/manifests/params.pp
#
# Synopsis:
#       Parameters for the openssl puppet module.


class openssl::params {

    case $::operatingsystem {
        Fedora: {

            $packages = [
                'openssl',
            ]

        }

        default: {
            fail ("The openssl module is not yet supported on ${operatingsystem}.")
        }

    }

}
