# Class: ntp::params
#
# This class defines default parameters used by the main module class ntp
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to ntp class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class ntp::params {

  ### Module specific parameters
  $server = 'pool.ntp.org'
  $runmode = 'service'


  ### Application related parameters

  $package = $::operatingsystem ? {
    default => 'ntp',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'ntp',
    default                   => 'ntpd',
  }

  $service_status = $::operatingsystem ? {
    default => true,
  }

  $process = $::operatingsystem ? {
    default => 'ntp',
  }

  $process_args = $::operatingsystem ? {
    default => '',
  }

  $process_user = $::operatingsystem ? {
    default => 'ntp',
  }

  $config_dir = $::operatingsystem ? {
    default => '/etc/ntp',
  }

  $config_file = $::operatingsystem ? {
    default => '/etc/ntp.conf',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_init = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/default/ntp',
    default                   => '/etc/sysconfig/ntpd',
  }

  $pid_file = $::operatingsystem ? {
    default => '/var/run/ntpd.pid',
  }

  $data_dir = $::operatingsystem ? {
    default => '/etc/ntp',
  }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    default => '',
  }

  $port = '123'
  $protocol = 'udp'

  # General Settings
  $my_class = ''
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = 'ntp/ntp.conf.erb'
  $options = ''
  $service_autorestart = true
  $version = 'present'
  $absent = false
  $disable = false
  $disableboot = false

  ### General module variables that can have a site or per module default
  $monitor = false
  $monitor_tool = ''
  $monitor_target = $::ipaddress
  $firewall = false
  $firewall_tool = ''
  $firewall_src = '0.0.0.0/0'
  $firewall_dst = $::ipaddress
  $puppi = false
  $puppi_helper = 'standard'
  $debug = false
  $audit_only = false

}
