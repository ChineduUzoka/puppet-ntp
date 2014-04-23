# Class: ntp::params
#
# This class is loaded in all the classes that use the values set here 
#
class ntp::params  {

## DEFAULTS FOR VARIABLES USERS CAN SET
# (Here are set the defaults, provide your custom variables externally)
# (The default used is in the line with '')

  $server = 'pool.ntp.org'


## MODULE INTERNAL VARIABLES

  $package_name = $::operatingsystem ? {
    default => 'ntp',
  }

  $service_name = $::operatingsystem ? {
    default => 'ntpd',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $config_file_init = $::operatingsystem ? {
    default => '/etc/init.d/ntpd',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/ntp.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_init_mode = $::operatingsystem ? {
    default => '0755',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/ntp',
  }

  $source = ''
  $source_dir = ''
  $source_dir_purge = ''
  $config_file_content = 'ntp/ntp.conf.erb'
  $options = ''
  $service_autorestart = true

}
