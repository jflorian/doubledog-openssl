# modules/openssl/manifests/params.pp
#
# == Class: openssl::params
#
# Parameters for the openssl puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2015 John Florian


class openssl::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            $packages = [
                'openssl',
            ]

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
