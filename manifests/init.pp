
class butterknife::common {
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

class butterknife::instance {
    include butterknife::common

    file { "/var/butterknife/persistent/sssd.conf":
	mode => 600,
        owner => root,
        group => root
    }
}

class butterknife::template {
    include butterknife::common

    file { "/var/lib/puppet/state/agent_disabled.lock":
        ensure => present,
        mode => 600,
        owner => root,
        group => root,
        content => "{\"disabled_message\":\"Puppet agent disabled for Butterknife templates, use puppet apply instead\"}"
    }

    if $architecture == "i386" or $architecture == "amd64" {
        include workstation::grub::enable
    }
    
    file_line { "hardware-clock-to-utc":
        path => "/etc/default/rcS",
        match => "^UTC=",
        line => "UTC=yes"
    }
    
    file { "/etc/butterknife/":
        ensure => directory,
        owner => root,
        group => root
    }
    ->
    file { "/etc/butterknife/postdeploy.d/":
        ensure => directory,
        recurse => true,
        purge => true,
        force => true,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/etc/butterknife/postdeploy.d/"
    }
    ->
    file { "/etc/butterknife/prerelease.d/":
        ensure => directory,
        recurse => true,
        purge => true,
        force => true,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/etc/butterknife/prerelease.d/"
    }
    ->
    file { "/usr/local/bin/butterknife-postdeploy":
        ensure => file,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-postdeploy"
    }
    ->
    file { "/usr/local/bin/butterknife-prerelease":
        ensure => file,
        mode => 755,
        owner => root,
        group => root,
        source => "puppet:///modules/butterknife/usr/bin/butterknife-prerelease"
    }
    
    
    # This is how we determine if it is an deployment or not
    file { "/var/persistent": ensure => absent }

    # Purge stuff that gets set up by butterknife-join-domain and symlinked by 85-domain-join-persistence
    file { "/etc/krb5.conf": ensure => absent }
    file { "/etc/samba/smb.conf": ensure => absent }
    file { "/etc/sssd/sssd.conf": ensure => absent }
    file { "/etc/krb5.keytab": ensure => absent }
        
    service { "sssd": ensure => stopped, enable => false }

}
