
class butterknife::template {
    include butterknife::common

    # Don't delete /etc/hostname, it's required to identify template name
    # for Puppet. Hostname file /etc/hostname is deleted by pre-release scripts
    # instead. Also Upstart job for (re)generating hostname is set up by pre-release scripts

    if $architecture == "i386" or $architecture == "amd64" {
        package { "grub-pc": ensure => installed } ->
        package { "os-prober": ensure => installed }
        ->
        file_line { "grub-detect-by-uuid":
            ensure => present,
            path => "/etc/default/grub",
            match => "^#?GRUB_DISABLE_LINUX_UUID=",
            line => "GRUB_DISABLE_LINUX_UUID=false"
        }
    }

    # Make symlink relative on jessie
    file { "/etc/resolv.conf":
        ensure => link,
        target => '../run/resolvconf/resolv.conf'
    }

    # local time is needed for dual-boot machines,
    # it's set in post-deploy scripts now.
    # template shall remain in UTC
    file_line { "hardware-clock-to-utc":
        path => "/etc/default/rcS",
        match => "^UTC=",
        line => "UTC=yes"
    }
}
