
class butterknife::template {
    include butterknife::common

    # Don't delete /etc/hostname, it's required to identify template name
    # for Puppet. Hostname file /etc/hostname is deleted by pre-release scripts
    # instead. Also Upstart job for (re)generating hostname is set up by pre-release scripts

    if $architecture == "i386" or $architecture == "amd64" {
        include workstation::grub::enable
    }

    # local time is needed for dual-boot machines,
    # it's set in post-deploy scripts now.
    # template shall remain in UTC
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
}
