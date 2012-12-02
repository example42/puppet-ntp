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
  $keys_file = $::operatingsystem ? {
    'Solaris' => '/etc/inet/ntp.keys',
    default   => '/etc/ntp/keys',
  }
  $keys_file_source = ''

  ### Application related parameters

  $package = $::operatingsystem ? {
    'Solaris' => $::operatingsystemrelease ? {
      '5.10'  => [ 'SUNWntpr' , 'SUNWntpu' ],
      default => 'ntp',
    },
    default => 'ntp',
  }

  $service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint|Solaris)/ => 'ntp',
    default                           => 'ntpd',
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
    'Solaris' => '/etc/inet',
    default   => '/etc/ntp',
  }

  $config_file = $::operatingsystem ? {
    'Solaris' => '/etc/inet/ntp.conf',
    default   => '/etc/ntp.conf',
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
    'Solaris' => '/var/run/ntp.pid',
    default   => '/var/run/ntpd.pid',
  }

  $data_dir = $::operatingsystem ? {
    'Solaris' => '/var/ntp',
    default   => '/var/lib/ntp',
 }

  $log_dir = $::operatingsystem ? {
    default => '',
  }

  $log_file = $::operatingsystem ? {
    default => '',
  }

  $drift_file = $::operatingsystem ? {
    /(?i:Ubuntu|Mint|Solaris)/ => "$data_dir/ntp.drift",
    default                    => "$data_dir/drift",
  }

  $use_local_clock = $::virtual ? {
    'vmware' => false, # See http://www.vmware.com/pdf/vmware_timekeeping.pdf page 18
    default  => true,
  }

  $tinker_panic = $::virtual ? {
    'vmware' => 0, # See http://www.vmware.com/pdf/vmware_timekeeping.pdf page 18
    default  => '',
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
