# Install the necessary packages for ntp
class ntp::install {
  if $ntp::package_name {
    package { $ntp::package_name:
      ensure => $ntp::managed_package_ensure,
    }
  }
}