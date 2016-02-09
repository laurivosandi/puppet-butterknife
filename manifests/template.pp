
class butterknife::template {
    include butterknife::common

    # Don't delete /etc/hostname, it's required to identify template name
    # for Puppet. Hostname file /etc/hostname is deleted by pre-release scripts
    # instead. Also Upstart job for (re)generating hostname is set up by pre-release scripts

    if $architecture == "i386" or $architecture == "amd64" {
        package { "grub-pc": ensure => installed } ->
        package { "os-prober": ensure => installed }
    }
}
