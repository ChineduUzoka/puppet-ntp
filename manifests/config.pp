# Configure ntp
class ntp::config {
  file { 'ntp.conf':
    ensure  => $ntp::managed_file_ensure,
    path    => $ntp::config_file,
    mode    => $ntp::config_file_mode,
    owner   => $ntp::config_file_owner,
    group   => $ntp::config_file_group,
    content => template($ntp::managed_file_content),
    source  => $ntp::managed_file_source,
    replace => $ntp::managed_file_replace,
    audit   => $ntp::managed_audit,
  }

  # The whole ntp configuration directory can be recursively overriden
  if $ntp::source_dir {
    file { 'ntp.dir':
      ensure  => $ntp::managed_dir_ensured,
      path    => $ntp::config_dir,
      source  => $ntp::source_dir,
      recurse => true,
      purge   => $ntp::source_dir_purge,
      replace => $ntp::managed_file_replace,
      audit   => $ntp::managed_audit,
    }
  }   
}
