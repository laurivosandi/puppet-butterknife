
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


    file { "/etc/butterknife/":
        ensure => directory,
        owner => root,
        group => root
    }
    ->
    file { "/etc/butterknife/deploy.d/":
        ensure => directory,
        recurse => true,
        purge => true,
        force => true,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/etc/butterknife/deploy.d/"
    }
    ->
    file { "/etc/butterknife/prepare.d/":
        ensure => directory,
        recurse => true,
        purge => true,
        force => true,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/etc/butterknife/prepare.d/"
    }
    ->
    file { "/usr/local/bin/butterknife-deploy":
        ensure => file,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-deploy"
    }
    ->
    file { "/usr/local/bin/butterknife-prepare":
        ensure => file,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-prepare"
    }
    ->
    file { "/etc/butterknife/menu.d/":
        ensure => directory,
        recurse => true,
        purge => true,
        force => true,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/etc/butterknife/menu.d/"
    }
    ->
    file { "/etc/butterknife/helpers/":
        ensure => directory,
        recurse => true,
        purge => true,
        force => true,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/etc/butterknife/helpers/"
    }

    # Purge old stuff
    file { "/etc/butterknife/action.d/":
        ensure => absent,
        recurse => true,
        purge => true,
        force => true
    }

    file { "/etc/butterknife/postdeploy.d/":
        ensure => absent,
        recurse => true,
        purge => true,
        force => true 
    }

    file { "/etc/butterknife/prerelease.d/":
        ensure => absent,
        recurse => true,
        purge => true,
        force => true 
    }

    file { "/usr/local/bin/butterknife-postdeploy":
        ensure => absent 
    }

    file { "/usr/local/bin/butterknife-prerelease":
        ensure => absent 
    }

    # Dialog script for creating local user with sudo capabilities
    file { "/usr/local/bin/butterknife-create-local-user":
        ensure => link,
        target => "/etc/butterknife/helpers/useradd"
    }

    # Provide hostname changing helper
    file { "/usr/local/bin/butterknife-change-hostname":
        ensure => link,
        target => "/etc/butterknife/helpers/change-hostname"
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
        ensure => link,
        target => "/etc/butterknife/helpers/join-domain"
    }

    file { "/var/log/lastlog":
        ensure => present,
        mode => 664,
        owner => root,
        group => utmp
    }

    file { "/var/log/wtmp":
        ensure => present,
        mode => 664,
        owner => root,
        group => utmp
    }

    file { "/var/log/btmp":
        ensure => present,
        mode => 660,
        owner => root,
        group => utmp
    }

    if $lsbdistcodename == "trusty" {
        # Set up Upstart job for creating swapfile in /var/cache/swapfile/
        file { "/etc/init/swapfile.conf":
            ensure => file,
            mode => 644,
            owner => root,
            group => root,
            source => "puppet:///modules/butterknife/etc/init/swapfile.conf"
        }
    }
}

