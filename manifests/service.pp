# Configure the ntp service

class ntp::service {

  if $ntp::service_name {
    service { $ntp::service_name:
      ensure  => $ntp::managed_service_ensure,
      enable  => $ntp::managed_service_enable,
      hasrestart => $ntp::service_status,
      hasstatus  => false, 
      pattern    => $ntp::process,
    }
  }

}

