
class butterknife::instance {
    include butterknife::common

    file { "/var/butterknife/persistent/sssd.conf":
	mode => 600,
        owner => root,
        group => root
    }
}

