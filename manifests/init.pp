# == Class: ntp
#
# This module manages ntp
# 
# == Parameters
#
# Module's specific parameters
# $server::              Ntp server(s) to use. Default values are from ntp.org. 
#                        type:array
#
# $force_startup_sync::  Set to true if you want to force an ntp sync if the local clock is off
#                        by more than 180 seconds (option -s) 
#                        type:boolean
#
# $file_init_content::   Location of the template to use for ntp init file.
#   
# Standard class parameters
# Define the general class behaviour and customizations
#
# $config_file_source::  Sets the content of source parameter for main configuration file. 
#                        If defined, ntp main config file will have the param: source => $source
#                        Template must be sent to template => '' for source value to be used
#
# $source_dir_source::   If defined, the whole ntp configuration directory content is retrieved recursively
#                        (source => $source_dir , recurse => true)
#
# $source_dir_purge::    Delete extraneous contents from destination directory.  Mirror with contents from $source_dir
#
# $config_file_template::Sets the path to the template to use as the content for main configuration file
#                        If defined, ntp main config file has: content => content("$template")
#                        Note source and template parameters are mutually exclusive: don't use both
#
# $options::             An hash of custom options to be used in templates for arbitrary settings.
#
# $service_autorestart:: Automatically restarts the ntp service when there is a change in
#                        configuration files. Default: true
#
# $uninstall::           Enable to remove package(s) installed by this module
#                        type:boolean
#
# $disable::             Enable to disable service(s) managed by module
#                        type:boolean
#
# $disableboot::         Enable to disable service(s) at boot, without checks if it's running
#                        type:boolean
#
# $debug::               Enable module debugging
#                        type:boolean
#
# $audit_only::          Set to 'true' if you don't intend to override existing configuration files
#                        and want to audit the difference between existing files and the ones
#                        managed by Puppet.
#                        Can be defined also by the (top scope) variables $ntp_audit_only
#                        and $audit_only
#                        type:boolean
#
# Default class params - As defined in ntp::params.
#
# $package_name::        The name of ntp package
#
# $service_name::        The name of ntp service
#
# $service_status::      If the ntp service init script supports status argument
#
# $config_file::         Main configuration file path
#
# $config_file_mode::    Main configuration file path mode
#
# $config_file_owner::   Main configuration file path owner
#
# $config_file_group::   Main configuration file path group
#
# $config_file_init::    Path of configuration file sourced by init script
#
# Usage:
# include ntp
#
class ntp (
  $server                = $ntp::params::server,
  
  $ensure                = 'present',
  $version               = undef,
  $audit_only            = undef,

  $package_name          = $ntp::params::package_name,

  $service_name          = $ntp::params::service_name,
  $service_ensure        = running,
  $service_enable        = true,

  $config_file           = $ntp::params::config_file,
  $config_file_owner     = $ntp::params::config_file_owner,
  $config_file_group     = $ntp::params::config_file_group,
  $config_file_mode      = $ntp::params::config_file_mode,
  $config_file_replace   = true,
  $config_file_content   = $ntp::params::config_file_content,
  $config_file_source    = undef,
  $config_file_template  = $ntp::params::config_file_template,

  $config_dir_path            = $ntp::params::config_dir_path,
  $config_dir_source          = undef,
  $config_dir_purge           = false,
  $config_dir_recurse         = false,

  $conf_hash             = undef
  
  ) inherits ntp::params {

  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent. WARNING: If set to absent all the resources managed by the module are removed.')
  validate_bool($service_enable)
  validate_bool($config_file_replace)
  validate_bool($config_dir_purge)
  validate_bool($config_dir_recurse)
  if $conf_hash { validate_hash($conf_hash) }
  
  ### Definition of some variables used in the module

  if $ntp::config_file_content {
    $managed_file_content = $ntp::config_file_content
  } else {
    if $ntp::config_file_template {
      $managed_file_content = $ntp::config_file_template
    } else {
      $managed_file_content = undef
    }
  }

  # Determine behaviour of module based on the values used

  if $ntp::version {
    $managed_package_ensure = $ntp::version
  } else {
    $managed_packaged_ensure = $ntp::ensure
  }

  if $ntp::ensure == 'absent' {
    $managed_service_enable = undef
    $managed_service_ensure = stopped
    $managed_dir_ensure = absent
    $managed_file_ensure = absent
  } else {
    $managed_service_enable = $ntp::service_enable
    $managed_service_ensure = $ntp::service_ensure
    $managed_dir_ensure = directory
    $managed_file_ensure = present
  }

  ### Managed resources

  include ntp::install, ntp::config, ntp::service
  Class[ 'ntp::install' ] ~>
  Class[ 'ntp::config' ] ~>
  Class[ 'ntp::service' ]

  ### Debugging, if enabled ( debug => true )
  if $ntp::bool_debug == true {
    file { 'debug_ntp':
      ensure  => $ntp::manage_file,
      path    => "${settings::vardir}/debug-ntp",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
