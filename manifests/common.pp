
class butterknife::common {

    # Script for generating /etc/hostname based on product serial number or
    # MAC address of the first network interface card.
    file { "/usr/bin/butterknife-generate-hostname":
        ensure => present,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-generate-hostname"
    }

    # Dialog script for creating local user with sudo capabilities
    file { "/usr/local/bin/butterknife-create-local-user":
        ensure => present,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-create-local-user"
    }

    # Provide hostname changing helper
    file { "/usr/local/bin/butterknife-change-hostname":
        ensure => present,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-change-hostname"
    }

    # Provide maintenance task menu: GRUB install, GRUB update, purge Puppet keys etc
    file { "/usr/local/bin/butterknife-maintenance":
        ensure => present,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-maintenance"
    }

    # Provide SSSD/winbind authentication
    file { "/usr/local/bin/butterknife-join-domain":
        ensure => present,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-join-domain"
    }
}

